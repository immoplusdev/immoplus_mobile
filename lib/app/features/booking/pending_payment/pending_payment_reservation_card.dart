import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:intl/intl.dart';

class PendingPaymentReservationCard extends StatelessWidget {
  PendingPaymentReservationCard({super.key, required this.reservationModel});
  final ReservationModel reservationModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    final nbJours = reservationModel.datesReservation.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.white,
          border: Border.all(color: AppColors.immoFeedbackNeutralSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Badge + Montant
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.orange50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.timer_1,
                        size: 14,
                        color: AppColors.immoFeedbackWarning,
                      ),
                      const Gap(4),
                      Text(
                        'EN ATTENTE',
                        style: AppTypography.font(
                          fontWeight: FontWeight.w600,
                          color: AppColors.amber800,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AutoSizeText(
                  maxLines: 1,
                  Utils.formatCurrency(
                      reservationModel.montantTotalReservation),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const Gap(12),

            // Nombre de jours
            Row(
              children: [
                Icon(Iconsax.calendar_1,
                    size: 16, color: AppColors.immoTextSecondary),
                const Gap(6),
                Text(
                  "$nbJours jour${nbJours > 1 ? 's' : ''} de réservation",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.immoTextLabel,
                      ),
                ),
              ],
            ),

            const Gap(12),
            Divider(thickness: 0.5, color: AppColors.immoBorderDefault, height: 1),
            const Gap(12),

            // Dates arrivée / départ
            Row(
              children: [
                Expanded(
                  child: _buildDateBlock(
                    context,
                    icon: Iconsax.login_1,
                    label: 'Arrivée',
                    date: formatDate
                        .format(Utils.toDateTime(reservationModel.dateDebut)),
                    time: reservationModel.residence.heureEntree,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.immoFeedbackNeutralSubtle,
                ),
                Expanded(
                  child: _buildDateBlock(
                    context,
                    icon: Iconsax.logout_1,
                    label: 'Départ',
                    date: formatDate
                        .format(Utils.toDateTime(reservationModel.dateFin)),
                    time: "avant ${reservationModel.residence.heureDepart}",
                  ),
                ),
              ],
            ),

            const Gap(16),

            // Bouton Payer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed(
                    OperatorsSelectorPage.name,
                    extra: PaymentPageAdapter(
                      itemId: reservationModel.id,
                      collection: ProductType.reservations.name,
                      amount: reservationModel.montantTotalReservation.toInt(),
                    ),
                  );
                },
                icon: const Icon(Iconsax.card, size: 18),
                label: Text('Payer maintenant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: AppTypography.font(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBlock(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String date,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.immoTextSecondary),
              const Gap(4),
              Text(
                label,
                style: AppTypography.font(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.immoTextSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Gap(4),
          AutoSizeText(
            maxLines: 1,
            date,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.immoTextLabel,
                ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.immoTextDisabled,
                ),
          ),
        ],
      ),
    );
  }
}
