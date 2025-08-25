import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/utils/residence_filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/residence_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'history_page_state.dart';

class ResidencesList extends StatefulWidget {
  const ResidencesList({super.key});

  @override
  State<ResidencesList> createState() => _ResidencesListState();
}

class _ResidencesListState extends State<ResidencesList> {
  Future<void> loadPage(int page) async {
    ResidenceRepository()
        .getResidences(
      search: FilterHandler.search,
      lat: FilterHandler.lat,
      long: FilterHandler.long,
      startDate: FilterHandler.startDate,
      endDate: FilterHandler.endDate,
      radius: (FilterHandler.lat != null) ? 100 : null,
      // where: {
      //   '_where': [
      //     '{"_field": "residenceDisponible", "_op": "eq", "_val": true}',
      //     '{"_field": "statusValidation", "_op": "eq", "_val": "valide"}',
      //   ],
      // },
      page: page,
    )
        .then((value) {
      if (value.hasNext == true) {
        HomePageState.pagingControllerResidence
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        HomePageState.pagingControllerResidence
            .appendLastPage(value.data ?? []);
      }
      //change(value, status: RxStatus.success());
    }).onError((error, stackTrace) {
      HomePageState.pagingControllerResidence.error = error.toString();
    });
  }

  @override
  void initState() {
    HomePageState.pagingControllerResidence = PagingController(firstPageKey: 1);
    HomePageState.pagingControllerResidence.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    HomePageState.pagingControllerResidence.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: PagedSliverList<int, ResidenceModel>(
        pagingController: HomePageState.pagingControllerResidence,
        builderDelegate: PagedChildBuilderDelegate(
          firstPageProgressIndicatorBuilder: (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              //height: 600,
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
            "Aucun élément trouvé",
            style: Theme.of(context).textTheme.titleLarge,
          )),
          itemBuilder: (context, item, index) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 1).copyWith(bottom: 13),
            child: ResidenceCard(
              residence: item,
            ),
          ),
        ),
      ),
    );
  }
}
