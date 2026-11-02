import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/error_feedback.dart';
import 'package:immoplus/app/data/models/auth/phone_challenge_models.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/widgets/custom_input.dart';

/// Ouvre le dialog d'authentification par téléphone (connexion ou inscription).
/// L'envoi du challenge se fait avec `channelPreference: "AUTO"` (l'étape de
/// choix manuel WhatsApp/SMS est conservée en commentaire ci-dessous).
Future<void> showLoginOtpDialog({
  required BuildContext context,
  required String phoneNumber,
  PhoneChallengeData? initialChallenge,
}) {
  final loginCubit = context.read<LoginCubit>();
  final parentContext = context;
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.black.withValues(alpha: 0.5),
    builder: (dialogContext) => BlocProvider.value(
      value: loginCubit,
      child: _LoginOtpFlowDialog(
        phoneNumber: phoneNumber,
        parentContext: parentContext,
        initialChallenge: initialChallenge,
      ),
    ),
  );
}

class _LoginOtpFlowDialog extends StatefulWidget {
  const _LoginOtpFlowDialog({
    required this.phoneNumber,
    required this.parentContext,
    this.initialChallenge,
  });

  final String phoneNumber;
  final BuildContext parentContext;
  final PhoneChallengeData? initialChallenge;

  @override
  State<_LoginOtpFlowDialog> createState() => _LoginOtpFlowDialogState();
}

class _LoginOtpFlowDialogState extends State<_LoginOtpFlowDialog> {
  final _otpController = TextEditingController();

  PhoneChallengeData? _challenge;
  OtpChannelPreference _channelPreference = OtpChannelPreference.auto;
  bool _isSendingChannel = false;
  bool _isSubmittingOtp = false;
  String? _otpError;
  String _lastSubmittedOtp = '';
  int _attemptsRemaining = 5;
  int _resendSecondsRemaining = 0;
  int _expirySecondsRemaining = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initialChallenge != null) {
      _applyChallenge(widget.initialChallenge!);
    } else {
      // Envoi automatique en mode "AUTO" à l'ouverture si aucun challenge initial n'est fourni
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendOtp(OtpChannelPreference.auto);
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _applyChallenge(PhoneChallengeData challenge) {
    _challenge = challenge;
    _attemptsRemaining = challenge.attemptsRemaining;
    _updateTimersFromChallenge();
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _updateTimersFromChallenge();
    });
  }

  void _updateTimersFromChallenge() {
    final now = DateTime.now();
    final resendAt = _challenge?.resendAvailableAt;
    final expiresAt = _challenge?.expiresAt;

    final nextResend = resendAt != null
        ? resendAt.difference(now).inSeconds.clamp(0, 3600)
        : 0;
    final nextExpiry = expiresAt != null
        ? expiresAt.difference(now).inSeconds.clamp(0, 3600)
        : 0;

    if (nextResend != _resendSecondsRemaining ||
        nextExpiry != _expirySecondsRemaining) {
      setState(() {
        _resendSecondsRemaining = nextResend;
        _expirySecondsRemaining = nextExpiry;
      });
    }
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _sendOtp(OtpChannelPreference preference) async {
    setState(() => _isSendingChannel = true);
    try {
      final formattedPhone =
          PhoneNumberHandler.formatPhoneNumber(widget.phoneNumber);
      final challenge =
          await context.read<LoginCubit>().createPhoneChallenge(
                phoneNumber: formattedPhone,
                channelPreference: preference,
              );
      if (!mounted) return;
      setState(() {
        _channelPreference = preference;
        _otpError = null;
        _applyChallenge(challenge);
      });
    } catch (e) {
      ErrorFeedback.present(
        AppErrorMapper.from(e),
        context: ErrorContext.authentication,
        retry: () => _sendOtp(preference),
      );
    } finally {
      if (mounted) setState(() => _isSendingChannel = false);
    }
  }

  Future<void> _resend() async {
    if (_resendSecondsRemaining > 0 || _isSendingChannel || _isSubmittingOtp) {
      return;
    }
    setState(() => _isSendingChannel = true);
    try {
      final formattedPhone =
          PhoneNumberHandler.formatPhoneNumber(widget.phoneNumber);
      final challenge =
          await context.read<LoginCubit>().createPhoneChallenge(
                phoneNumber: formattedPhone,
                channelPreference: _channelPreference,
              );
      if (!mounted) return;

      _otpController.clear();
      setState(() {
        _otpError = null;
        _applyChallenge(challenge);
      });

      ToastUtils.showSuccess(
        title: "Code renvoyé",
        description:
            'Un nouveau code a été envoyé par ${challenge.isWhatsapp ? 'WhatsApp' : 'SMS'}.',
      );
    } catch (e) {
      ErrorFeedback.present(
        AppErrorMapper.from(e),
        context: ErrorContext.authentication,
        retry: _resend,
      );
    } finally {
      if (mounted) setState(() => _isSendingChannel = false);
    }
  }

  void _submitOtp(String code) {
    final challengeId = _challenge?.challengeId;
    if (challengeId == null || challengeId.isEmpty) return;

    final trimmed = code.trim();
    setState(() {
      _isSubmittingOtp = true;
      _otpError = null;
      _lastSubmittedOtp = trimmed;
    });
    context.read<LoginCubit>().onVerifyPhoneChallenge(
          challengeId: challengeId,
          otp: trimmed,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginCubitState>(
      listener: (context, state) {
        if (!_isSubmittingOtp) return;
        if (state is LOGIN_SUCCESS) {
          Navigator.of(context).pop();
        } else if (state is LOGIN_INITIAL) {
          final loginCubit = context.read<LoginCubit>();
          final profileRequired = loginCubit.lastProfileRequired;

          // Nouveau numéro : 422 PROFILE_REQUIRED -> ouvrir le formulaire profil
          // avec le même challengeId et le code OTP validé.
          if (profileRequired != null) {
            final formattedPhone =
                PhoneNumberHandler.formatPhoneNumber(widget.phoneNumber);
            final otpCode = _lastSubmittedOtp;
            Navigator.of(context).pop();
            if (widget.parentContext.mounted) {
              widget.parentContext.pushNamed(
                CustomerRegistration.name,
                extra: DataRouterRegistration(
                  email: null,
                  token: '',
                  phoneNumber: formattedPhone,
                  challengeId: profileRequired.challengeId,
                  otp: otpCode,
                ),
              );
            }
            return;
          }

          final error = loginCubit.lastOtpError;
          // Refus lié au code : message sous le champ. Sinon (403, 409, réseau,
          // serveur) le coordinateur a déjà présenté l'erreur.
          final inline = error == null || LoginCubit.isInlineOtpError(error);
          // Vider le champ déclenche `onChanged`, qui efface l'erreur : on le
          // fait avant de poser le message.
          _otpController.clear();
          setState(() {
            _isSubmittingOtp = false;
            if (inline && _attemptsRemaining > 0) {
              _attemptsRemaining--;
            }
            _otpError = inline
                ? (error?.message ??
                    'Code invalide ou expiré. Veuillez réessayer.')
                : null;
          });
        }
      },
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Iconsax.close_circle,
                      size: 22,
                      color: AppColors.immoTextSecondary,
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  // Le choix manuel du canal est désactivé au profit de "AUTO" :
                  // child: _step == 0 ? _buildChoiceStep() : _buildOtpStep(),
                  child: _buildOtpStep(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
  // ─────────────────────────────────────────────────────────────────────────
  // Étape de choix manuel du canal (WhatsApp / SMS) — conservée en commentaire
  // car l'application envoie désormais directement `channelPreference: "AUTO"`.
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildChoiceStep() {
    return Column(
      key: const ValueKey('choice-step'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recevoir le code par',
          textAlign: TextAlign.center,
          style: AppTypography.h4.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const Gap(12),
        Text(
          'Choisissez comment vous souhaitez recevoir votre code de vérification.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.immoTextSecondary,
          ),
        ),
        const Gap(24),
        CustomButtom(
          text: 'WhatsApp',
          borderRadius: BorderRadius.circular(28),
          isLoading: _isSendingChannel,
          onClick: () => _sendOtp(OtpChannelPreference.whatsapp),
        ),
        const Gap(10),
        SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: _isSendingChannel
                ? null
                : () => _sendOtp(OtpChannelPreference.sms),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              'SMS',
              style: AppTypography.button.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
  */

  Widget _buildOtpStep() {
    final theme = Theme.of(context);
    final isWhatsapp = _challenge?.isWhatsapp ?? true;
    final destination = (_challenge?.maskedDestination.isNotEmpty == true)
        ? _challenge!.maskedDestination
        : widget.phoneNumber;
    final isExpired =
        _challenge?.expiresAt != null && _expirySecondsRemaining <= 0;

    return Column(
      key: const ValueKey('otp-step'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isWhatsapp
              ? 'Entrez le code reçu par WhatsApp'
              : 'Entrez le code reçu par SMS',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          isWhatsapp
              ? 'Un code à 6 chiffres a été envoyé par WhatsApp au $destination'
              : 'Un code à 6 chiffres a été envoyé par SMS au $destination',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(24),
        Center(
          child: CustomPinput(
            controller: _otpController,
            enabled: !_isSubmittingOtp &&
                !_isSendingChannel &&
                !isExpired &&
                _attemptsRemaining > 0,
            errorText: _otpError,
            onCompleted: _submitOtp,
            onChanged: (code) {
              if (_otpError != null) {
                setState(() => _otpError = null);
              }
            },
          ),
        ),
        const Gap(12),
        if (_challenge != null)
          Text(
            isExpired
                ? 'Ce code a expiré. Demandez un nouveau code.'
                : 'Expire dans ${_formatDuration(_expirySecondsRemaining)} • $_attemptsRemaining essai${_attemptsRemaining > 1 ? 's' : ''} restant${_attemptsRemaining > 1 ? 's' : ''}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isExpired ? AppColors.red : AppColors.immoTextSecondary,
            ),
          ),
        if (_isSubmittingOtp || _isSendingChannel) ...[
          const Gap(16),
          const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ],
        const Gap(16),
        Center(
          child: TextButton(
            onPressed: (_isSendingChannel ||
                    _isSubmittingOtp ||
                    _resendSecondsRemaining > 0)
                ? null
                : _resend,
            child: Text(
              _resendSecondsRemaining > 0
                  ? 'Renvoyer le code (${_resendSecondsRemaining}s)'
                  : 'Renvoyer le code',
            ),
          ),
        ),
      ],
    );
  }
}
