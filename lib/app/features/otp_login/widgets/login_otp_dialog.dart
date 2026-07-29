import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/enums/account_source.dart';
import 'package:immoplus/app/data/models/auth/login_otp_body.dart';
import 'package:immoplus/app/data/models/auth/send_opt_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';
import 'package:immoplus/app/utils/status_code_handler.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_input.dart';

/// Ouvre un AppDialog à deux étapes pour la connexion par téléphone : choix
/// du canal (WhatsApp/SMS) puis saisie du code OTP, sans naviguer vers une
/// page séparée (même pattern que l'inscription).
Future<void> showLoginOtpDialog({
  required BuildContext context,
  required String phoneNumber,
}) {
  final loginCubit = context.read<LoginCubit>();
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) => BlocProvider.value(
      value: loginCubit,
      child: _LoginOtpFlowDialog(phoneNumber: phoneNumber),
    ),
  );
}

class _LoginOtpFlowDialog extends StatefulWidget {
  const _LoginOtpFlowDialog({required this.phoneNumber});

  final String phoneNumber;

  @override
  State<_LoginOtpFlowDialog> createState() => _LoginOtpFlowDialogState();
}

class _LoginOtpFlowDialogState extends State<_LoginOtpFlowDialog> {
  final _otpController = TextEditingController();

  int _step = 0;
  bool? _isWhatsapp;
  bool _isSendingChannel = false;
  bool _isSubmittingOtp = false;
  String? _otpError;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  // Les échecs d'envoi (réseau, utilisateur introuvable, etc.) sont déjà
  // affichés par l'ErrorInterceptor global (bottom sheet). On ne montre donc
  // rien ici en cas d'erreur pour éviter un double affichage.
  Future<void> _sendOtp(bool useWhatsapp) async {
    setState(() => _isSendingChannel = true);
    try {
      final model = SendOptModel(
        phoneNumber: PhoneNumberHandler.formatPhoneNumber(widget.phoneNumber),
      );
      final response = useWhatsapp
          ? await AuthRepository().sendWhatsappOtp(body: model)
          : await AuthRepository().sendOtp(body: model);
      if (!mounted) return;

      if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
        setState(() {
          _isWhatsapp = useWhatsapp;
          _step = 1;
        });
      }
    } catch (e) {
      // Erreur déjà affichée par l'ErrorInterceptor global.
    } finally {
      if (mounted) setState(() => _isSendingChannel = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _isSendingChannel = true);
    try {
      final model = SendOptModel(
        phoneNumber: PhoneNumberHandler.formatPhoneNumber(widget.phoneNumber),
      );
      final response = _isWhatsapp == true
          ? await AuthRepository().sendWhatsappOtp(body: model)
          : await AuthRepository().sendOtp(body: model);
      if (!mounted) return;

      if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
        _showSnack(
          'Un nouveau code a été envoyé par ${_isWhatsapp == true ? 'WhatsApp' : 'SMS'}.',
          Colors.green,
        );
      }
    } catch (e) {
      // Erreur déjà affichée par l'ErrorInterceptor global.
    } finally {
      if (mounted) setState(() => _isSendingChannel = false);
    }
  }

  void _showSnack(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  void _submitOtp(String code) {
    setState(() {
      _isSubmittingOtp = true;
      _otpError = null;
    });
    context.read<LoginCubit>().onSendOtpData(
          body: LoginOtpBody(
            phoneNumber:
                PhoneNumberHandler.formatPhoneNumber(widget.phoneNumber),
            otp: code.trim(),
            source: AccountSource.customerApp.value,
          ),
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
          setState(() {
            _isSubmittingOtp = false;
            _otpError = 'Code invalide ou expiré. Veuillez réessayer.';
            _otpController.clear();
          });
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
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
                    child: const Icon(
                      Iconsax.close_circle,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  child: _step == 0 ? _buildChoiceStep() : _buildOtpStep(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceStep() {
    return Column(
      key: const ValueKey('choice-step'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recevoir le code par',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            height: 1.3,
          ),
        ),
        const Gap(12),
        Text(
          'Choisissez comment vous souhaitez recevoir votre code de vérification.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
            height: 1.5,
          ),
        ),
        const Gap(24),
        CustomButtom(
          text: 'WhatsApp',
          borderRadius: BorderRadius.circular(28),
          isLoading: _isSendingChannel,
          onClick: () => _sendOtp(true),
        ),
        const Gap(10),
        SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: _isSendingChannel ? null : () => _sendOtp(false),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              'SMS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    final theme = Theme.of(context);

    return Column(
      key: const ValueKey('otp-step'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _isWhatsapp == true
              ? 'Entrez le code reçu par WhatsApp'
              : 'Entrez le code reçu par SMS',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          _isWhatsapp == true
              ? 'Un code à 6 chiffres a été envoyé par WhatsApp au ${widget.phoneNumber}'
              : 'Un code à 6 chiffres a été envoyé par SMS au ${widget.phoneNumber}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(24),
        Center(
          child: CustomPinput(
            controller: _otpController,
            enabled: !_isSubmittingOtp,
            errorText: _otpError,
            onCompleted: _submitOtp,
            onChanged: (code) {
              if (_otpError != null) {
                setState(() => _otpError = null);
              }
            },
          ),
        ),
        if (_isSubmittingOtp) ...[
          const Gap(20),
          const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ],
        const Gap(20),
        Center(
          child: TextButton(
            onPressed: (_isSendingChannel || _isSubmittingOtp) ? null : _resend,
            child: const Text('Renvoyer le code'),
          ),
        ),
      ],
    );
  }
}
