import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/home_page/components/empty_elements_indicator.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class EstatesList extends StatefulWidget {
  const EstatesList({super.key});

  @override
  State<EstatesList> createState() => _EstatesListState();
}

class _EstatesListState extends State<EstatesList> {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  Future<void> loadPage(int page) async {
    final whereFilters = FilterHandler.getAllFilters(PropertyType.estate);
    bienImmobilierRepository
        .getBiensImmobiliers(
      page: page,
      search: FilterHandler.search,
      lat: FilterHandler.lat,
      long: FilterHandler.long,
      startDate: FilterHandler.startDate,
      endDate: FilterHandler.endDate,
      // radius: (FilterHandler.lat != null) ? 100 : null,
      where: whereFilters,
    )
        .then((value) {
      if (value.hasNext == true) {
        HomePageState.pagingControllerEstate
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        HomePageState.pagingControllerEstate.appendLastPage(value.data ?? []);
      }
      //change(value, status: RxStatus.success());
    }).onError((error, stackTrace) {
      // inspect(error);
      // inspect(stackTrace);
      HomePageState.pagingControllerEstate.error = error.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    if (!HomePageState.isListenerAttached(2)) {
      HomePageState.pagingControllerEstate
          .addPageRequestListener((pageKey) {
        loadPage(pageKey);
      });
      HomePageState.setListenerAttached(2, true);
    }
    HomePageState.pagingControllerEstate.refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: PagedSliverList<int, BienImmobilierModel>(
        pagingController: HomePageState.pagingControllerEstate,
        builderDelegate: PagedChildBuilderDelegate(
          firstPageProgressIndicatorBuilder: (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              child: Column(
                children: List.generate(
                  10,
                  (index) => LoadProductCard(),
                ),
              ),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) =>
              const EmptyElementsIndicator(
            titlePrefix: 'Aucun',
            titleSufix: 'Bien à louer',
            subTitle: "Aucun bien immobilier à louer trouvé",
          ),
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 1,
            ),
            child: EstateCard(
              bienImmobilierModel: item,
            ),
          ),
        ),
      ),
    );
  }
}
