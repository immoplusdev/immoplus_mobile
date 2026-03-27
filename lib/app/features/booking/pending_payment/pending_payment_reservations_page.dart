import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservation_card.dart';
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservations_cubit.dart';
import 'package:immoplus/app/features/booking_history/components/booking_loading_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PendingPaymentReservationsPage extends StatefulWidget {
  final String? reservationId;
  static const String name = 'PENDING_PAYMENT_RESERVATIONS';

  static String routePath() => '/pending-payment-reservations';

  static String route({String? reservationId}) {
    return reservationId != null
        ? '/pending-payment-reservations?reservationId=$reservationId'
        : '/pending-payment-reservations';
  }

  const PendingPaymentReservationsPage({super.key, this.reservationId});

  @override
  State<PendingPaymentReservationsPage> createState() =>
      _PendingPaymentReservationsPageState();
}

class _PendingPaymentReservationsPageState
  extends State<PendingPaymentReservationsPage> {
  late final PendingPaymentReservationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PendingPaymentReservationsCubit>();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservations à payer'),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
        backgroundColor: AppColors.whiteBackground,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                _cubit.pagingController.refresh();
              },
            ),
            const SliverGap(8),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: PagedSliverList<int, ReservationModel>(
                pagingController: _cubit.pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  firstPageProgressIndicatorBuilder: (context) => Column(
                    children: List.generate(
                      5,
                      (index) => const BookingLoadingCard(),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(80),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Iconsax.tick_circle,
                            size: 36,
                            color: Color(0xFF12B76A),
                          ),
                        ),
                        const Gap(24),
                        Text(
                          "Tout est à jour !",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const Gap(8),
                        Text(
                          "Aucune réservation en attente de paiement. Toutes vos réservations sont réglées.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF667085),
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context, item, index) =>
                      PendingPaymentReservationCard(
                    reservationModel: item,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
