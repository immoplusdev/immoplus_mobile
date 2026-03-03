import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/booking_history/components/booking_history_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final PagingController<int, ReservationModel> _pagingController =
      PagingController(firstPageKey: 1);
  final ResidenceRepository residenceRepository = getIt<ResidenceRepository>();

  Future<void> loadPage(int page) async {
    residenceRepository
        .getReservations(
      page: page,
      perPage: 5,
      orderBy: OrderByField.createdAt.value,
      orderDir: OrderDir.desc.value,
      // where: '{"_field": "statusReservation", "_op": "eq", "_val": "valide"}',
    )
        .then((value) {
      if (value.hasNext == true) {
        _pagingController.appendPage(value.data, (value.currentPage) + 1);
      } else {
        _pagingController.appendLastPage(value.data);
      }
    }).onError((error, stackTrace) {
      _pagingController.error = error.toString();
    });
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.reservationId != null) {
        showModalBottomSheet(
          backgroundColor: AppColors.scafold,
          showDragHandle: true,
          enableDrag: true,
          isScrollControlled: true,
          useRootNavigator: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          context: context,
          builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: BookingDetailPage(
                id: widget.reservationId!,
              )),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des réservations'),
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
              ),
            ),
          ),
        ],
      )),
    );
  }
}
