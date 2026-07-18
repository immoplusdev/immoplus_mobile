import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// Dialog 1 : choix du canal d'envoi (WhatsApp ou SMS).
/// Retourne 'whatsapp', 'sms', ou null si l'utilisateur ferme le dialog.
/// Aucune logique métier ici : c'est à l'appelant de déclencher l'envoi réel.
Future<String?> showChannelChoiceDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
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
              const SizedBox(height: 12),
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
              const SizedBox(height: 24),

              // Bouton WhatsApp (rempli)
              CustomButtom(
                text: 'WhatsApp',
                borderRadius: BorderRadius.circular(28),
                onClick: () => Navigator.of(ctx).pop('whatsapp'),
              ),
              const SizedBox(height: 10),

              // Bouton SMS (contour)
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop('sms'),
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
          ),
        ),
      );
    },
  );
}

/// Dialog 2 : saisie du code OTP.
/// Retourne le code saisi (String) quand l'utilisateur valide, ou null si fermé.
/// Le paramètre onResend est un simple callback UI (pas d'appel réseau ici).
Future<String?> showOtpInputDialog(
  BuildContext context, {
  required String phoneNumber,
  required bool isWhatsapp,
  String? errorText,
  VoidCallback? onResend,
}) {
  final otpController = TextEditingController();
  // Déclarées ici (hors du builder) pour persister entre les setState.
  String? currentError = errorText;
  bool isCodeComplete = false;

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Icon(
                        Icons.close,
                        size: 22,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    isWhatsapp
                        ? 'Entrez le code reçu par WhatsApp'
                        : 'Entrez le code reçu par SMS',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Un code à 6 chiffres a été envoyé au $phoneNumber',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Champ OTP (6 cases)
                  Center(
                    child: Pinput(
                      length: 6,
                      controller: otpController,
                      defaultPinTheme: PinTheme(
                        width: 45,
                        height: 45,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: currentError != null
                                ? Colors.red
                                : AppColors.primary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 45,
                        height: 45,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          currentError = null;
                          isCodeComplete = value.length == 6;
                        });
                      },
                      onCompleted: (code) {
                        setState(() => isCodeComplete = true);
                      },
                    ),
                  ),

                  if (currentError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      currentError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Bouton Valider
                  CustomButtom(
                    text: 'Valider',
                    borderRadius: BorderRadius.circular(28),
                    onClick: isCodeComplete
                        ? () => Navigator.of(ctx).pop(otpController.text)
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // Bouton Renvoyer
                  Center(
                    child: TextButton(
                      onPressed: onResend,
                      child: Text(
                        'Renvoyer le code',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
