import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FurnituresList extends StatefulWidget {
  const FurnituresList({super.key});

  @override
  State<FurnituresList> createState() => _FurnituresListState();
}

class _FurnituresListState extends State<FurnituresList> {
  Future<void> loadPage(int page) async {
    // LogmentRepository.getResidences(page: page).then((value) {
    //   if (value.hasNext == true) {
    //     _pagingController.appendPage(
    //         value.data ?? [], (value.currentPage)! + 1);
    //   } else {
    //     _pagingController.appendLastPage(value.data ?? []);
    //   }
    //   //change(value, status: RxStatus.success());
    // }).onError((error, stackTrace) {
    //   _pagingController.error = error.toString();
    // });
  }

  @override
  void initState() {
    HomePageState.pagingControllerFurniture = PagingController(firstPageKey: 1);
    HomePageState.pagingControllerFurniture.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    HomePageState.pagingControllerFurniture.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      sliver: SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                FontAwesomeIcons.couch,
                size: 80,
                color: Colors.grey,
              ),
            ),
            Text(
              'Aucun éléments',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.primary),
            ),
            const Gap(10),
            Text(
              "Actuellement, aucun meuble n'est disponible à la vente. Nous vous proposerons très bientôt une large sélection de magnifiques meubles que vous pourrez commander en toute simplicité.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );

    // SliverPadding(
    //   padding: const EdgeInsets.symmetric(horizontal: 9),
    //   sliver: PagedSliverList<int, BienImmobilierModel>(
    //     pagingController: HomePageState.pagingControllerFurniture,
    //     builderDelegate: PagedChildBuilderDelegate(
    //       firstPageProgressIndicatorBuilder: (context) => Padding(
    //         padding: const EdgeInsets.all(10),
    //         child: SizedBox(
    //           //height: 600,
    //           child: Column(
    //             children: List.generate(
    //               10,
    //               (index) => LoadProductCard(),
    //             ),
    //           ),
    //         ),
    //       ),
    //       noItemsFoundIndicatorBuilder: (context) => Center(
    //           child: Text(
    //         "Aucun élément trouvé",
    //         style: Theme.of(context).textTheme.titleLarge,
    //       )),
    //       itemBuilder: (context, item, index) => EstateCard(
    //         bienImmobilierModel: item,
    //       ),
    //     ),
    //   ),
    // );
  }
}
