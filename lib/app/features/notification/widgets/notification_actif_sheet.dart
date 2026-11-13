import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// Bottom sheet proposant d'activer les notifications. Les actions sont
/// pilotées par l'appelant (voir [NotificationPermissionService]).
class NotificationActifSheet extends StatelessWidget {
  const NotificationActifSheet({
    super.key,
    required this.onAccept,
    required this.onMaybeLater,
  });

  final VoidCallback onAccept;
  final VoidCallback onMaybeLater;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final bottomGap = bottomPadding > 0 ? bottomPadding + 16 : 28.0;

    return PopScope(
      canPop: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomGap),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.immoBrandPrimarySubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.notification,
                  size: 32,
                  color: AppColors.immoBrandPrimary,
                ),
              ),
              const Gap(20),
              Text(
                'Activez les notifications pour ne manquer aucune réponse à vos réservations.',
                textAlign: TextAlign.center,
                style: AppTypography.font(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.immoTextPrimary,
                  height: 1.5,
                ),
              ),
              const Gap(12),
              const _BenefitRow(
                icon: Iconsax.calendar_tick,
                label: 'Réponse du propriétaire en temps réel',
              ),
              const _BenefitRow(
                icon: Iconsax.tick_circle,
                label: 'Confirmations et rappels de séjour',
              ),
              const _BenefitRow(
                icon: Iconsax.card,
                label: 'Alertes de paiement',
              ),
              const Gap(24),
              CustomButtom(
                text: 'Recevoir des notifications',
                color: AppColors.immoBrandPrimary,
                borderRadius: BorderRadius.circular(25),
                fontSize: 16,
                onClick: onAccept,
              ),
              const Gap(8),
              TextButton(
                onPressed: onMaybeLater,
                child: Text(
                  'Peut-être plus tard',
                  style: AppTypography.font(
                    fontSize: 15,
                    color: AppColors.immoTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.immoBrandPrimary),
          const Gap(10),
          Expanded(
            child: Text(
              label,
              style: AppTypography.font(
                fontSize: 13,
                color: AppColors.immoTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
