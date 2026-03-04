import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/furniture_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FurnituresList extends StatefulWidget {
  const FurnituresList({super.key});

  @override
  State<FurnituresList> createState() => _FurnituresListState();
}

class _FurnituresListState extends State<FurnituresList> {
  Future<void> loadPage(int page) async {
    final whereFilters = FilterHandler.getAllFilters(PropertyType.furniture);
    FurnitureRepository furnitureRepository = getIt<FurnitureRepository>();
    furnitureRepository
        .getFurnitures(
      search: FilterHandler.search,
      lat: FilterHandler.lat,
      long: FilterHandler.long,
      startDate: FilterHandler.startDate,
      endDate: FilterHandler.endDate,
      where: whereFilters,
      page: page,
    )
        .then((value) {
      if (value.hasNext == true) {
        HomePageState.pagingControllerFurniture
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        HomePageState.pagingControllerFurniture
            .appendLastPage(value.data ?? []);
      }
    }).onError((error, stackTrace) {
      HomePageState.pagingControllerFurniture.error = error.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    if (!HomePageState.isListenerAttached(1)) {
      HomePageState.pagingControllerFurniture
          .addPageRequestListener((pageKey) {
        loadPage(pageKey);
      });
      HomePageState.setListenerAttached(1, true);
    }
    HomePageState.pagingControllerFurniture.refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: PagedSliverList<int, FurnitureModel>(
        pagingController: HomePageState.pagingControllerFurniture,
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
          noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text(
            "Aucun meuble trouvé",
            style: Theme.of(context).textTheme.titleLarge,
          )),
          itemBuilder: (context, item, index) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 1).copyWith(bottom: 13),
            child: FurnitureCard(
              furniture: item,
            ),
          ),
        ),
      ),
    );
  }
}
