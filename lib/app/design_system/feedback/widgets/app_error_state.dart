import 'package:flutter/material.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/error_messages.dart';
import 'package:immoplus/app/design_system/tokens/app_colors.dart';
import 'package:immoplus/app/design_system/tokens/app_typography.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// État d'erreur affiché dans l'écran lorsque le contenu principal n'a pas pu
/// être chargé, avec « Réessayer ». Utilise les mêmes textes que le dialogue
/// (`ErrorMessages`).
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.error,
    required this.context,
    this.onRetry,
  });

  final AppError error;
  final ErrorContext context;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext buildContext) {
    final text = ErrorMessages.describe(error, context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              error is NetworkError
                  ? Icons.wifi_off_rounded
                  : Icons.error_outline_rounded,
              size: 48,
              color: AppColors.immoTextDisabled,
            ),
            const SizedBox(height: 16),
            Text(
              text.title,
              textAlign: TextAlign.center,
              style: AppTypography.h4.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.immoTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text.message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.immoTextSecondary,
              ),
            ),
            if (onRetry != null && error.retryable) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: CustomButtom(
                  text: 'Réessayer',
                  borderRadius: BorderRadius.circular(25),
                  onClick: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
