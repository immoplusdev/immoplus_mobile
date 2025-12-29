import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/booking_history/components/booking_loading_card.dart';
import 'package:immoplus/app/features/visit_history/components/visit_history_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VisitHistoryPage extends StatefulWidget {
  const VisitHistoryPage({super.key});
  static String name = 'VISIT_HISTORY_PAGE';
  static String routePath() => '/visites-history';

  static String route() => routePath();
  @override
  State<VisitHistoryPage> createState() => _VisitHistoryPageState();
}

class _VisitHistoryPageState extends State<VisitHistoryPage> {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  final PagingController<int, DemandeVisiteModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> loadPage(int page) async {
    bienImmobilierRepository
        .getVisites(
      page: page,
      perPage: 5,
      orderBy: OrderByField.createdAt.value,
      orderDir: OrderDir.desc.value,
      // where: {
      //   '_where': [
      //     '{"_field": "statusReservation", "_op": "eq", "_val": "valide"}',
      //   ],
      // },
    )
        .then((value) {
      if (value.hasNext == true) {
        _pagingController.appendPage(value.data ?? [], (value.currentPage) + 1);
      } else {
        _pagingController.appendLastPage(value.data ?? []);
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
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        title: const Text("Historique des Visites"),
      ),
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          const SliverGap(15),
          PagedSliverList<int, DemandeVisiteModel>(
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
              noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(80),
                  SvgPicture.asset(
                    "assets/svgs/undraw/5.svg",
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
              )),
              itemBuilder: (context, item, index) => VisitHistoryCard(
                demandeVisiteModel: item,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
