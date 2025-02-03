import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/home_page/components/empty_elements_indicator.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/estate_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class EstatesList extends StatefulWidget {
  const EstatesList({super.key});

  @override
  State<EstatesList> createState() => _EstatesListState();
}

class _EstatesListState extends State<EstatesList> {
  Future<void> loadPage(int page) async {
    BienImmobilierRepository()
        .getBiensImmobiliers(page: page, perPage: 5, where: {
      '_where': [
        '{"_field": "bienImmobilierDisponible", "_op": "eq", "_val": true}',
        '{"_field": "statusValidation", "_op": "eq", "_val": "valide"}',
        '{"_field": "aLouer", "_op": "eq", "_val": true}'
      ],
    }).then((value) {
      if (value.hasNext == true) {
        HomePageState.pagingControllerEstate
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        HomePageState.pagingControllerEstate.appendLastPage(value.data ?? []);
      }
      //change(value, status: RxStatus.success());
    }).onError((error, stackTrace) {
      HomePageState.pagingControllerEstate.error = error.toString();
    });
  }

  @override
  void initState() {
    HomePageState.pagingControllerEstate = PagingController(firstPageKey: 1);
    HomePageState.pagingControllerEstate.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    HomePageState.pagingControllerEstate.dispose();
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
