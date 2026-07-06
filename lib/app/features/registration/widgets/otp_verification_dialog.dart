import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/auth/verify_email_response.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_input.dart';

/// Ouvre un AppDialog à deux étapes : choix du canal (WhatsApp/SMS) puis
/// saisie du code OTP, sans naviguer vers une page séparée.
Future<void> showOtpVerificationDialog({
  required BuildContext context,
  required String phoneNumber,
  required void Function(VerifyEmailResponse response) onVerified,
  bool barrierDismissible = true,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) => _OtpFlowDialog(
      phoneNumber: phoneNumber,
      onVerified: (response) {
        Navigator.of(dialogContext).pop();
        onVerified(response);
      },
    ),
  );
}

class _OtpFlowDialog extends StatefulWidget {
  const _OtpFlowDialog({
    required this.phoneNumber,
    required this.onVerified,
  });

  final String phoneNumber;
  final void Function(VerifyEmailResponse response) onVerified;

  @override
  State<_OtpFlowDialog> createState() => _OtpFlowDialogState();
}

class _OtpFlowDialogState extends State<_OtpFlowDialog> {
  final _otpController = TextEditingController();

  int _step = 0;
  bool? _isWhatsapp;
  bool _isLoading = false;
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
    setState(() => _isLoading = true);
    final cubit = context.read<RgistrationCubitCubit>();
    final success = await cubit.userSendOTP(
      phoneNumber: widget.phoneNumber,
      is_whatssap: useWhatsapp,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      setState(() {
        _isWhatsapp = useWhatsapp;
        _step = 1;
      });
    }
  }

  Future<void> _resend() async {
    setState(() => _isLoading = true);
    final cubit = context.read<RgistrationCubitCubit>();
    final ok = await cubit.userSendOTP(
      phoneNumber: widget.phoneNumber,
      is_whatssap: _isWhatsapp,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Un nouveau code a été envoyé par ${_isWhatsapp == true ? 'WhatsApp' : 'SMS'}.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _submit(String code) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _otpError = null;
    });

    final cubit = context.read<RgistrationCubitCubit>();
    final resp = await cubit.verifyOtp(
      phoneNumber: widget.phoneNumber,
      otp: code.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (resp is VerifyEmailResponse) {
      widget.onVerified(resp);
    } else {
      setState(() {
        _otpError = 'Code invalide ou expiré. Veuillez réessayer.';
        _otpController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
    );
  }

  Widget _buildChoiceStep() {
    return Column(
      key: const ValueKey('choice-step'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Envoyer le code par',
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
          isLoading: _isLoading,
          onClick: () => _sendOtp(true),
        ),
        const Gap(10),
        SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => _sendOtp(false),
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
            enabled: !_isLoading,
            errorText: _otpError,
            onCompleted: _submit,
            onChanged: (code) {
              if (_otpError != null) {
                setState(() => _otpError = null);
              }
            },
          ),
        ),
        if (_isLoading) ...[
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
            onPressed: _isLoading ? null : _resend,
            child: const Text('Renvoyer le code'),
          ),
        ),
      ],
    );
  }
}
