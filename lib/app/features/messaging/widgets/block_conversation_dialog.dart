import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/design_system/design_system.dart';

/// Confirmation de blocage dans une modale arrondie, cohérente avec les
/// feuilles d'action de la messagerie.
Future<void> showBlockConversationDialog(
  BuildContext context, {
  required String hostLabel,
  required Future<bool> Function() onConfirm,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      bool isLoading = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.immoFeedbackError.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Iconsax.shield_cross,
                        color: AppColors.immoFeedbackError),
                  ),
                  const SizedBox(height: 16),
                  Text('Bloquer $hostLabel ?',
                      style: AppTypography.font(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    'Vous ne pourrez plus envoyer ni recevoir de messages dans cette conversation.',
                    textAlign: TextAlign.center,
                    style: AppTypography.font(
                        fontSize: 13, color: AppColors.immoTextSecondary),
                  ),
                  const SizedBox(height: 22),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(dialogContext).pop(),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.immoFeedbackError),
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                try {
                                  final success = await onConfirm();
                                  if (!dialogContext.mounted) return;
                                  if (success) {
                                    Navigator.of(dialogContext).pop();
                                  } else {
                                    setState(() => isLoading = false);
                                  }
                                } catch (_) {
                                  if (dialogContext.mounted) {
                                    setState(() => isLoading = false);
                                  }
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Bloquer'),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
