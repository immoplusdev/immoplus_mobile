import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/booking_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/data/enums/rating_status.dart';
import 'package:immoplus/app/features/rating/widgets/rating_bottom_sheet.dart';

class BookingHistoryCard extends StatelessWidget {
  const BookingHistoryCard({
    super.key,
    required this.reservationModel,
    this.clickable = true,
    this.onRefresh,
  });

  final ReservationModel reservationModel;
  final bool clickable;
  final VoidCallback? onRefresh;

  Color _paymentColor() =>
      Utils.getServiceStatusColor(reservationModel.statusFacture);

  String _paymentLabel() =>
      Utils.getServiceStatus(reservationModel.statusFacture);

  bool get _isRatingPending =>
      reservationModel.ratingStatus == RatingStatus.pending;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM yyyy');
    final checkin = Utils.toDateTime(reservationModel.dateDebut);
    final checkout = Utils.toDateTime(reservationModel.dateFin);
    final nights = reservationModel.datesReservation.length;

    final bookingStatus = BookingUtils.getBookingStatus(
      reservationModel.datesReservation.first.date!,
      reservationModel.datesReservation.last.date!,
    );
    final isOngoing = bookingStatus == BookingStatus.ongoing;
    final statusColor = isOngoing ? const Color(0xFF1CA53F) : Colors.blueGrey;
    final statusLabel = BookingUtils.getStatusText(
      startDate: reservationModel.datesReservation.first.date!,
      endDate: reservationModel.datesReservation.last.date!,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: InkWell(
          onTap: clickable
              ? () async {
                  if (_isRatingPending) {
                    final result = await RatingBottomSheet.show(context,
                        reservation: reservationModel);
                    if (result == true) {
                      onRefresh?.call();
                    }
                  } else {
                    context
                        .push(BookingDetailPage.route(id: reservationModel.id));
                  }
                }
              : null,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── En-tête : image + nom + badges ──
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: reservationModel.residence.images.isNotEmpty
                                ? Image(
                                    image: Utils.getImage(
                                        id: reservationModel
                                            .residence.images.first),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _placeholder(),
                                  )
                                : _placeholder(),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reservationModel.residence.nom,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const Gap(6),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _Badge(
                                    label: statusLabel,
                                    color: statusColor,
                                    icon: isOngoing
                                        ? Iconsax.people
                                        : Iconsax.calendar,
                                  ),
                                  _Badge(
                                    label: _paymentLabel(),
                                    color: _paymentColor(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(4),
                        Icon(Iconsax.arrow_right_3,
                            size: 16, color: Colors.grey[400]),
                      ],
                    ),
                  ),

                  Divider(
                      height: 1, thickness: 0.5, color: Colors.grey.shade100),

                  // ── Dates ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: _DateCell(
                            label: 'ARRIVÉE',
                            date: fmt.format(checkin),
                            icon: Iconsax.login,
                            color: const Color(0xFF1CA53F),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: Colors.grey.shade200,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Expanded(
                          child: _DateCell(
                            label: 'DÉPART',
                            date: fmt.format(checkout),
                            icon: Iconsax.logout,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                      height: 1, thickness: 0.5, color: Colors.grey.shade100),

                  // ── Nuits + montant ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.moon,
                                size: 14, color: Colors.grey[500]),
                            const Gap(4),
                            Text(
                              '$nights ${nights > 1 ? 'jours' : 'jour'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        Text(
                          Utils.formatCurrency(reservationModel.montantPaye),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isRatingPending)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800), // Orange/Gold for rating
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.star1, size: 12, color: Colors.white),
                        Gap(4),
                        Text(
                          'À évaluer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.primaryLite,
        child: Icon(Iconsax.home_1, color: AppColors.primary, size: 24),
      );
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.icon});
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const Gap(3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.label,
    required this.date,
    required this.icon,
    required this.color,
  });
  final String label;
  final String date;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 10, color: color),
            const Gap(3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const Gap(2),
        Text(
          date,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
