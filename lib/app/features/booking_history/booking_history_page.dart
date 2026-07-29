import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/booking_history/components/booking_history_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

import 'components/booking_loading_card.dart';

class BookingHistoryPage extends StatefulWidget {
  final String? reservationId;
  const BookingHistoryPage({super.key, this.reservationId});
  static String name = 'BOOKING_HISTORY';

  static String routePath() => '/booking-history';

  static String route({String? reservationId}) {
    return reservationId != null
        ? '/booking-history?reservationId=$reservationId'
        : '/booking-history';
  }

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage>
    with ConnectivityMixin {
  final PagingController<int, ReservationModel> _pagingController =
      PagingController(firstPageKey: 1);
  final ResidenceRepository residenceRepository = getIt<ResidenceRepository>();

  @override
  void onConnectionRestored() {
    if (_pagingController.itemList == null ||
        _pagingController.itemList!.isEmpty) {
      _pagingController.error = 'temporary_error_to_force_refresh';
      _pagingController.refresh();
    }
  }

  Future<void> loadPage(int page) async {
    try {
      final value = await residenceRepository.getReservations(
        page: page,
        perPage: 5,
        orderBy: OrderByField.createdAt.value,
        orderDir: OrderDir.desc.value,
      );
      if (value.hasNext == true) {
        _pagingController.appendPage(value.data, value.currentPage + 1);
      } else {
        _pagingController.appendLastPage(value.data);
      }
    } catch (e) {
      showConnectionErrorDialog();
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.reservationId != null) {
        context.push(BookingDetailPage.route(id: widget.reservationId!));
      }
    });

    super.initState();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    super.dispose();

    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Historique De Réservations'),
        backgroundColor: AppColors.whiteBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, size: 24),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/account'),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          const SliverGap(15),
          PagedSliverList<int, ReservationModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                    //height: 600,
                    child: Column(
                  children: List.generate(
                    20,
                    (index) => const BookingLoadingCard(),
                  ),
                )),
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
                      "Aucune Réservation Pour le Moment",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(20),
                    const Text(
                      "Votre tableau de bord est prêt à accueillir vos prochaines réservations. Ajoutez vos résidences dès maintenant pour commencer à recevoir des demandes !",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              itemBuilder: (context, item, index) => BookingHistoryCard(
                reservationModel: item,
                onRefresh: () => _pagingController.refresh(),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
