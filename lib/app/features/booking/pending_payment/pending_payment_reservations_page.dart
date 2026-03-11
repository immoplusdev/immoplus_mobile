import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
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
        title: const Text('Reservations a payer'),
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
            const SliverGap(15),
            PagedSliverList<int, ReservationModel>(
              pagingController: _cubit.pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                firstPageProgressIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(
                      5,
                      (index) => const BookingLoadingCard(),
                    ),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(80),
                      SvgPicture.asset(
                        "assets/svgs/undraw/4.svg",
                        width: 200,
                      ),
                      const Gap(30),
                      Text(
                        "Aucune reservation en attente de paiement",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
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
          ],
        ),
      ),
    );
  }
}
