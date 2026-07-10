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
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/utils/PromoCarrousel/promo_carousel_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_residence_card.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/features/home_page/screens/location_residences_page.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class ResidencesList extends StatefulWidget {
  const ResidencesList({super.key});

  @override
  State<ResidencesList> createState() => _ResidencesListState();
}

class _ResidencesListState extends State<ResidencesList> {
  bool _isParentLoading = true;
  List<_LocationSectionData> _activeSections = [];
  List<dynamic> _displayList = [];

  void _onPageRequest(int pageKey) => loadPage(pageKey);

  Future<void> loadPage(int page) async {
    final myToken = HomePageState.residenceToken;

    final whereFilters = FilterHandler.getAllFilters(PropertyType.residence);
    final residenceRepository = getIt<ResidenceRepository>();
    try {
      final value = await residenceRepository.getResidences(
        search: FilterHandler.search,
        lat: FilterHandler.lat,
        long: FilterHandler.long,
        startDate: FilterHandler.startDate,
        endDate: FilterHandler.endDate,
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
    _loadAllSections();
  }

  @override
  void dispose() {
    HomePageState.pagingControllerResidence
        .removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  Future<void> _loadAllSections() async {
    if (!mounted) return;
    setState(() {
      _isParentLoading = true;
    });

    try {
      final futures = _residencesHomeItems.map((item) async {
        if (item.isHeader) return null;

        final Map<String, dynamic> where = {};
        if (item.villeId != null) {
          where['_villeId'] = item.villeId;
        }
        if (item.communeId != null) {
          where['_communeId'] = item.communeId;
        }

        try {
          final result = await getIt<ResidenceRepository>().getResidences(
            page: 1,
            perPage: 10,
            where: where,
          );
          final list = result.data ?? [];
          // if (list.isNotEmpty) {
          return _LocationSectionData(
            title: item.title,
            villeId: item.villeId,
            communeId: item.communeId,
            residences: list,
          );
          // }
        } catch (e) {
          debugPrint('Error loading section ${item.title}: $e');
        }
        return null;
      }).toList();

      final results = await Future.wait(futures);

      final List<_LocationSectionData> active = [];
      for (var r in results) {
        if (r != null) {
          active.add(r);
        }
      }

      if (mounted) {
        setState(() {
          _activeSections = active;
          _displayList = _buildDisplayList();
          _isParentLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isParentLoading = false;
        });
      }
    }
  }

  List<dynamic> _buildDisplayList() {
    final List<dynamic> list = [];
    for (var item in _residencesHomeItems) {
      if (item.isHeader) continue;

      final loaded = _activeSections.cast<_LocationSectionData?>().firstWhere(
            (s) =>
                s != null &&
                s.villeId == item.villeId &&
                s.communeId == item.communeId,
            orElse: () => null,
          );
      bool isLoad = loaded != null && loaded.residences.isNotEmpty;
      // bool isLoad = loaded != null; pour afficher les empty state

      if (isLoad) {
        list.add(loaded);
      }
    }
    return list;
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
                    ValueListenableBuilder<int>(
                      valueListenable: FilterHandler.notifier,
                      builder: (context, _, __) {
                        if (FilterHandler.search != null &&
                            FilterHandler.search!.isNotEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (permissionState.isGranted)
                              const ResidencesNearList(),
                            const ResidencesBestRatedList(),
                          ],
                        );
                      },
                    ),
                    // const HomeSectionTitle(title: "Ce qu'il vous faut"),
                    // const Gap(13),
                  ],
                ),
              ),
            );
          },
        ),
        if (_isParentLoading)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(15),
                        const SizedBox(
                          width: 150,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          height: 255,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            separatorBuilder: (context, index) => const Gap(12),
                            itemBuilder: (context, index) => SizedBox(
                              width: neirResidenceCardWidth,
                              child: LoadProductCard(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (!_isParentLoading)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _displayList[index] as _LocationSectionData;
                  return ResidencesHorizontalListByLocation(
                    key: ValueKey(
                        'location_residences_${item.villeId ?? item.communeId}'),
                    title: item.title,
                    villeId: item.villeId,
                    communeId: item.communeId,
                    residences: item.residences,
                  );
                },
                childCount: _displayList.length,
              ),
            ),
          ),
        // SliverPadding(
        //   padding: const EdgeInsets.symmetric(horizontal: 12),
        //   sliver: PagedSliverList<int, ResidenceModel>(
        //     pagingController: HomePageState.pagingControllerResidence,
        //     builderDelegate: PagedChildBuilderDelegate(
        //       firstPageProgressIndicatorBuilder: (context) => Padding(
        //         padding: const EdgeInsets.all(10),
        //         child: SizedBox(
        //           child: Column(
        //             children: List.generate(
        //               10,
        //               (index) => LoadProductCard(),
        //             ),
        //           ),
        //         ),
        //       ),
        //       noItemsFoundIndicatorBuilder: (context) => Center(
        //         child: Text(
        //           "Aucun élément trouvé",
        //           style: Theme.of(context).textTheme.titleLarge,
        //         ),
        //       ),
        //       itemBuilder: (context, item, index) => Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 1)
        //             .copyWith(bottom: 13),
        //         child: UnifiedPropertyCard(
        //           item: item,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class ResidencesHomeListItem {
  final String title;
  final String? villeId;
  final String? communeId;
  final bool isHeader;

  const ResidencesHomeListItem({
    required this.title,
    this.villeId,
    this.communeId,
    this.isHeader = false,
  });
}

final List<ResidencesHomeListItem> _residencesHomeItems = [
  // --- Section 1 : Villes populaires ---
  const ResidencesHomeListItem(title: "VILLES POPULAIRES", isHeader: true),
  const ResidencesHomeListItem(
      title: "Abidjan", villeId: "8b97b9ce-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Aboisso", villeId: "8b981afc-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Anyama", villeId: "8b9806f9-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Grand-Bassam", villeId: "8b981ba8-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Yamoussoukro", villeId: "8b97d0b3-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "San-Pédro", villeId: "8b97ea35-a507-11ef-8b44-0e595bc2ce41"),

  // --- Section 2 : Communes d'Abidjan ---
  // const ResidencesHomeListItem(title: "COMMUNES D'ABIDJAN", isHeader: true),
  const ResidencesHomeListItem(
      title: "Abobo", communeId: "8bb4b211-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Adjamé", communeId: "55a42f68-2867-11f1-a056-661ac3bf2f34"),
  const ResidencesHomeListItem(
      title: "Attécoubé", communeId: "8bb4d4d0-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Cocody", communeId: "8bb446ea-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Koumassi", communeId: "8bb4b588-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Marcory", communeId: "8bb498f3-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Plateau (Le Plateau)",
      communeId: "8bb48973-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Port-Bouët", communeId: "8bb4c15a-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Treichville", communeId: "8bb4a496-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Yopougon", communeId: "8bb47716-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Anyama (Commune)",
      communeId: "567aa860-2867-11f1-a056-661ac3bf2f34"),
  const ResidencesHomeListItem(
      title: "Bingerville", communeId: "8bb68343-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Bonoua", communeId: "8bb80dca-a507-11ef-8b44-0e595bc2ce41"),

  // --- Section 3 : Villes extérieures ---
  // const ResidencesHomeListItem(title: "VILLES EXTÉRIEURES", isHeader: true),
  const ResidencesHomeListItem(
      title: "Abengourou", villeId: "8b980686-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Adzopé", villeId: "8b981bef-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Agboville", villeId: "8b981b46-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Bondoukou", villeId: "8b980e6a-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Bouaké", villeId: "8b97dccc-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Daloa", villeId: "8b97e49c-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Divo", villeId: "8b97f856-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Ferkessédougou", villeId: "8b980eb7-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Gagnoa", villeId: "8b97f23e-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Issia", villeId: "8b981c4e-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Korhogo", villeId: "8b97ea95-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Man", villeId: "8b97f0aa-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Odienné", villeId: "8b9814b6-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Séguéla", villeId: "8b981507-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Soubré", villeId: "8b980dd8-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Toumodi", villeId: "8b981aa6-a507-11ef-8b44-0e595bc2ce41"),
];

class ResidencesHorizontalListByLocation extends StatelessWidget {
  final String title;
  final String? villeId;
  final String? communeId;
  final List<ResidenceModel> residences;

  const ResidencesHorizontalListByLocation({
    super.key,
    required this.title,
    this.villeId,
    this.communeId,
    required this.residences,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeSectionTitle(title: title),
            TextButton(
              onPressed: residences.isNotEmpty
                  ? () {
                      context.push(
                        LocationResidencesPage.routePath,
                        extra: {
                          'title': title,
                          'villeId': villeId,
                          'communeId': communeId,
                        },
                      );
                    }
                  : null,
              child: Text(
                'Voir plus',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: residences.isNotEmpty
                      ? AppColors.primary
                      : Colors.grey.shade400,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
        if (residences.isEmpty)
          Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  color: Colors.grey.shade400,
                  size: 28,
                ),
                const Gap(6),
                Text(
                  "Aucune résidence disponible dans cette localité",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 255,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: residences.length,
              separatorBuilder: (context, index) => const Gap(12),
              itemBuilder: (context, index) {
                return CompactResidenceCard(
                  residence: residences[index],
                  showRating: false,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _LocationSectionData {
  final String title;
  final String? villeId;
  final String? communeId;
  final List<ResidenceModel> residences;

  _LocationSectionData({
    required this.title,
    this.villeId,
    this.communeId,
    required this.residences,
  });
}

class AppPrimaryColors {
  // Couleur principale
  static const Color primary = kPrimaryColor;

  // Variantes plus claires
  static const Color primary50 = Color(0xffEEF1FC); // Très clair (backgrounds)
  static const Color primary100 = Color(0xffC5CFF5); // Clair
  static const Color primary200 = Color(0xff9BADEF); //
  static const Color primary300 = Color(0xff6B85E6); //
  static const Color primary400 = Color(0xff4A64E2); // Légèrement plus clair

  // Variantes plus foncées
  static const Color primary600 = Color(0xff1E35B8); // Plus foncé
  static const Color primary700 = Color(0xff182A92); // Foncé
  static const Color primary800 = Color(0xff121F6C); // Très foncé
  static const Color primary900 = Color(0xff0C1446); // Extra foncé
}
// class _PromoSection extends StatelessWidget {
//   const _PromoSection();

//   static const List<PromoCardData> _promoItems = [
//     PromoCardData(backgroundImage: 'assets/promo/promo_1.JPG'),
//     PromoCardData(backgroundImage: 'assets/promo/promo_2.JPG'),
//     PromoCardData(backgroundImage: 'assets/promo/promo_3.JPG'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return PromoCarousel(
//       items: _promoItems,
//       cardWidth: 300,
//       cardHeight: 325,
//       spacing: 12,
//     );
//   }
// }
