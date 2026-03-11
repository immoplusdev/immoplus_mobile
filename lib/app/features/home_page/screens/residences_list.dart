import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_state.dart';
import 'package:immoplus/app/features/home_page/screens/residences_best_rated_list.dart';
import 'package:immoplus/app/features/home_page/screens/residences_near_list.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/section_title.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/residence_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ResidencesList extends StatefulWidget {
  const ResidencesList({super.key});

  @override
  State<ResidencesList> createState() => _ResidencesListState();
}

class _ResidencesListState extends State<ResidencesList> {
  void _onPageRequest(int pageKey) => loadPage(pageKey);

  Future<void> loadPage(int page) async {
    final myToken = HomePageState.residenceToken;

    // utiliser le token pour invalider les requêtes périmées
    // si le token est différent, la requête est périmée et on ne la charge pas
    // cela permet d`eviter d`avoir des requêtes périmées en arrière-plan
    // qui rendent la liste de résidences invalide et vide
    final whereFilters = FilterHandler.getAllFilters(PropertyType.residence);
    final residenceRepository = getIt<ResidenceRepository>();
    try {
      final value = await residenceRepository.getResidences(
        search: FilterHandler.search,
        lat: FilterHandler.lat,
        long: FilterHandler.long,
        startDate: FilterHandler.startDate,
        endDate: FilterHandler.endDate,
        // radius: (FilterHandler.lat != null) ? 100 : null,
        where: whereFilters,
        page: page,
      );
      if (myToken != HomePageState.residenceToken) return;
      if (value.hasNext == true) {
        HomePageState.pagingControllerResidence
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        HomePageState.pagingControllerResidence
            .appendLastPage(value.data ?? []);
      }
    } catch (error) {
      if (myToken != HomePageState.residenceToken) return;
      HomePageState.pagingControllerResidence.error = error.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    HomePageState.pagingControllerResidence
        .addPageRequestListener(_onPageRequest);
    HomePageState.refreshResidences();
  }

  @override
  void dispose() {
    HomePageState.pagingControllerResidence
        .removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        BlocBuilder<LocationPermissionCubit, LocationPermissionState>(
          builder: (context, permissionState) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (permissionState.isGranted) const ResidencesNearList(),
                    const ResidencesBestRatedList(),
                    SectionTitle(title: "Ce qu'il vous faut"),
                    const Gap(13),
                  ],
                ),
              ),
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: PagedSliverList<int, ResidenceModel>(
            pagingController: HomePageState.pagingControllerResidence,
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
                  "Aucun élément trouvé",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              itemBuilder: (context, item, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1)
                    .copyWith(bottom: 13),
                child: ResidenceCard(
                  residence: item,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
