import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/home_page/components/empty_elements_indicator.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/estate_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LandsList extends StatefulWidget {
  const LandsList({super.key});

  @override
  State<LandsList> createState() => _LandsListState();
}

class _LandsListState extends State<LandsList> {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  Future<void> loadPage(int page) async {
    bienImmobilierRepository
        .getBiensImmobiliers(page: page, perPage: 5, where: {
      '_where': [
        '{"_field": "bienImmobilierDisponible", "_op": "eq", "_val": true}',
        '{"_field": "statusValidation", "_op": "eq", "_val": "valide"}',
        '{"_field": "aLouer", "_op": "eq", "_val": false}'
      ],
    }).then((value) {
      if (value.hasNext == true) {
        HomePageState.pagingControllerLand
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        HomePageState.pagingControllerLand.appendLastPage(value.data ?? []);
      }
      //change(value, status: RxStatus.success());
    }).onError((error, stackTrace) {
      HomePageState.pagingControllerLand.error = error.toString();
    });
  }

  @override
  void initState() {
    HomePageState.pagingControllerLand = PagingController(firstPageKey: 1);
    HomePageState.pagingControllerLand.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    HomePageState.pagingControllerLand.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      sliver: PagedSliverList<int, BienImmobilierModel>(
        pagingController: HomePageState.pagingControllerLand,
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
            titleSufix: 'Bien à acheter',
            subTitle: "Aucun bien immobilier à acheter trouvé",
          ),
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: EstateCard(
              bienImmobilierModel: item,
            ),
          ),
        ),
      ),
    );
  }
}
