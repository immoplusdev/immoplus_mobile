import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/tokens/app_colors.dart';
import 'package:immoplus/app/design_system/tokens/app_typography.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// Dialogue d'erreur standard du design system : titre clair, explication
/// compréhensible, action principale et, si pertinent, « Réessayer » ou
/// « Se reconnecter ».
///
/// Ne se construit pas directement dans les features : passer par
/// `ErrorFeedbackCoordinator`.
class AppErrorDialog {
  AppErrorDialog._();

  static Future<void> show({
    required String title,
    required String message,
    String closeLabel = 'Fermer',

    /// Action principale (« Réessayer », « Se reconnecter »). Sans elle, le
    /// bouton principal ferme simplement le dialogue.
    String? actionLabel,
    VoidCallback? onAction,

    /// Référence à communiquer au support (requestId), affichée discrètement.
    String? reference,
  }) async {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: actionLabel == null,
      barrierColor: AppColors.black.withValues(alpha: 0.5),
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: AppColors.immoFeedbackError,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.immoTextPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.immoTextSecondary,
                ),
              ),
              if (reference != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Référence : $reference',
                  textAlign: TextAlign.center,
                  style: AppTypography.font(
                    fontSize: 12,
                    color: AppColors.immoTextDisabled,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              CustomButtom(
                text: actionLabel ?? closeLabel,
                borderRadius: BorderRadius.circular(25),
                onClick: () {
                  Navigator.of(ctx).pop();
                  if (actionLabel != null) onAction?.call();
                },
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    closeLabel,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.immoTextSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
