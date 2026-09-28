import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:immoplus/app/design_system/design_system.dart';

/// Modal affiché quand l'utilisateur tente une nouvelle réservation
/// alors qu'il en a déjà une active (en attente propriétaire ou paiement).
class ActiveReservationBlockedModal extends StatelessWidget {
  final String message;
  final VoidCallback? onViewReservation;

  const ActiveReservationBlockedModal({
    super.key,
    required this.message,
    this.onViewReservation,
  });

  static Future<void> showAsModal(
    BuildContext context, {
    required String message,
    VoidCallback? onViewReservation,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        clipBehavior: Clip.antiAlias,
        child: _ActiveReservationBlockedContent(
          message: message,
          onViewReservation: () {
            Navigator.of(ctx).pop();
            onViewReservation?.call();
          },
          onDismiss: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ActiveReservationBlockedContent(
      message: message,
      onViewReservation: onViewReservation,
    );
  }
}

class _ActiveReservationBlockedContent extends StatelessWidget {
  final String message;
  final VoidCallback? onViewReservation;
  final VoidCallback? onDismiss;

  const _ActiveReservationBlockedContent({
    required this.message,
    this.onViewReservation,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Animation Lottie ──────────────────────────────────────────
              Container(
                color: AppColors.previewBackground,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Lottie.asset(
                  'assets/lotties/agenda.json',
                  height: 140,
                  repeat: true,
                ),
              ),

              // ── Contenu ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  children: [
                    Text(
                      'Réservation en cours',
                      textAlign: TextAlign.center,
                      style: AppTypography.font(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.immoBrandPrimary,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTypography.font(
                        fontSize: 14,
                        color: AppColors.immoTextLabel,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 28),

                    // ── Bouton principal ──────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onViewReservation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.immoBrandPrimary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Voir ma réservation',
                          style: AppTypography.font(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // ── Bouton secondaire ─────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onDismiss,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.immoTextSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Plus tard',
                          style: AppTypography.font(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Bouton fermer (coin) ──────────────────────────────────────────
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onDismiss,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.close, color: AppColors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
