import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/booking_history/components/booking_loading_card.dart';
import 'package:immoplus/app/features/visit_history/components/visit_history_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class VisitHistoryPage extends StatefulWidget {
  const VisitHistoryPage({super.key});
  static String name = 'VISIT_HISTORY_PAGE';
  static String routePath() => '/visites-history';

  static String route() => routePath();
  @override
  State<VisitHistoryPage> createState() => _VisitHistoryPageState();
}

class _VisitHistoryPageState extends State<VisitHistoryPage>
    with ConnectivityMixin {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  final PagingController<int, DemandeVisiteModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void onConnectionRestored() {
    if (_pagingController.itemList == null ||
        _pagingController.itemList!.isEmpty) {
      _pagingController.error = 'temporary_error_to_force_refresh';
      _pagingController.refresh();
    }
  }

  Future<void> loadPage(int page) async {
    bienImmobilierRepository
        .getVisites(
      page: page,
      perPage: 5,
      orderBy: OrderByField.createdAt.value,
      orderDir: OrderDir.desc.value,
    )
        .then((value) {
      if (value.hasNext == true) {
        _pagingController.appendPage(value.data ?? [], (value.currentPage) + 1);
      } else {
        _pagingController.appendLastPage(value.data ?? []);
      }
    }).onError((error, stackTrace) {
      showConnectionErrorDialog();
    });
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
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
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Historiques Des Visites'),
        backgroundColor: AppColors.whiteBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, size: 24),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          const SliverGap(8),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: PagedSliverList<int, DemandeVisiteModel>(
              pagingController: _pagingController,
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
                          color: AppColors.primaryLite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Iconsax.calendar_search,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const Gap(24),
                      Text(
                        "Aucune visite pour le moment",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Gap(8),
                      Text(
                        "Vos demandes de visite apparaîtront ici. Explorez nos résidences et planifiez votre première visite !",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF667085),
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, item, index) => VisitHistoryCard(
                  demandeVisiteModel: item,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
