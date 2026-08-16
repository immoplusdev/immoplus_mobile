import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/enums/ad_placement.dart';
import 'package:immoplus/app/data/enums/ad_type.dart';
import 'package:immoplus/app/widgets/ads/ad_widget.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:immoplus/app/utils/connectivity_mixin.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/constants/constantes.dart';

class ResidencesList extends StatefulWidget {
  const ResidencesList({super.key});

  @override
  State<ResidencesList> createState() => _ResidencesListState();
}

class _ResidencesListState extends State<ResidencesList>
    with ConnectivityMixin {
  final List<_LocationSectionData> _displayList = [];
  bool _isBackgroundLoading = false;

  void _onPageRequest(int pageKey) => loadPage(pageKey);

  @override
  void onConnectionRestored() {
    if (_displayList.isEmpty && !_isBackgroundLoading) {
      _loadAllSectionsInBackground();
    }
  }

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
    _loadAllSectionsInBackground();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    HomePageState.pagingControllerResidence
        .removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  Future<void> _loadAllSectionsInBackground() async {
    if (!mounted) return;
    setState(() {
      _isBackgroundLoading = true;
      _displayList.clear();
    });

    try {
      final itemsToLoad = _homeItems.where((i) => !i.isHeader).toList();
      const int batchSize = 2; // Fetch in light batches of 2 in background

      for (int i = 0; i < itemsToLoad.length; i += batchSize) {
        if (!mounted) break;
        final batch = itemsToLoad.sublist(
            i,
            i + batchSize > itemsToLoad.length
                ? itemsToLoad.length
                : i + batchSize);

        final futures = batch.map((item) async {
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
            if (list.isNotEmpty) {
              return _LocationSectionData(
                title: item.title,
                villeId: item.villeId,
                communeId: item.communeId,
                residences: list,
              );
            }
          } catch (e) {
            debugPrint('Error loading section ${item.title}: $e');
          }
          return null;
        }).toList();

        final results = await Future.wait(futures);
        if (!mounted) break;

        final List<_LocationSectionData> loadedSections = [];
        for (var r in results) {
          if (r != null) {
            loadedSections.add(r);
          }
        }

        if (loadedSections.isNotEmpty) {
          setState(() {
            _displayList.addAll(loadedSections);
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBackgroundLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adsState = context.watch<AdsCubit>().state;
    final allCampaigns = adsState.maybeWhen(
      success: (list) => list,
      orElse: () => <AdCampaignModel>[],
    );
    final ads = allCampaigns
        .where((c) => c.placement == AdPlacement.residenceList.value)
        .toList();

    // Merge ads into the section list based on positionIndex
    final List<dynamic> listItems = [..._displayList];
    final indexedAds = ads.where((ad) => ad.positionIndex != null).toList()
      ..sort((a, b) => a.positionIndex!.compareTo(b.positionIndex!));

    int insertedCount = 0;
    for (final ad in indexedAds) {
      final target = ad.positionIndex! + 1 + insertedCount; // "after the N-th element" (0-based)
      if (target >= 0 && target <= listItems.length) {
        listItems.insert(target, ad);
        insertedCount++;
      }
    }

    // Insère la pub dédiée de chaque localisation (ex: RESIDENCE_LIST_YOPOUGON)
    // juste après sa section, pour que l'espacement pub (haut/bas) reste géré
    // à un seul endroit (voir `topGap` dans le SliverList ci-dessous).
    final List<dynamic> finalItems = [];
    for (final entry in listItems) {
      finalItems.add(entry);
      if (entry is _LocationSectionData && entry.residences.isNotEmpty) {
        final placement = _adPlacementForLocation(
          villeId: entry.villeId,
          communeId: entry.communeId,
        );
        final matches = allCampaigns
            .where((c) => c.placement == placement.value)
            .toList()
          ..sort((a, b) => b.priority.compareTo(a.priority));
        if (matches.isNotEmpty) {
          finalItems.add(_LocationAdSlot(
            placement,
            AdType.fromString(matches.first.type),
          ));
        }
      }
    }

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
                  ],
                ),
              ),
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: _isBackgroundLoading && _displayList.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: List.generate(
                      2,
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
                              height: compactResidenceCardHeight,
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
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = finalItems[index];
                      final isPub =
                          item is AdCampaignModel || item is _LocationAdSlot;
                      final previousItem =
                          index > 0 ? finalItems[index - 1] : null;
                      final previousIsPub = previousItem is AdCampaignModel ||
                          previousItem is _LocationAdSlot;
                      final topGap = index == 0
                          ? 0.0
                          : isPub
                              ? _pubGapFor(item)
                              : previousIsPub
                                  ? _pubGapFor(previousItem)
                                  : kHomeSectionSpacing;

                      late final Widget child;
                      if (item is AdCampaignModel) {
                        child = AdWidget(
                          placement: AdPlacement.residenceList,
                          index: item.positionIndex,
                        );
                      } else if (item is _LocationAdSlot) {
                        child = AdWidget(placement: item.placement);
                      } else {
                        final section = item as _LocationSectionData;
                        child = ResidencesHorizontalListByLocation(
                          key: ValueKey(
                              'location_residences_${section.villeId ?? section.communeId}'),
                          title: section.title,
                          villeId: section.villeId,
                          communeId: section.communeId,
                          residences: section.residences,
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.only(top: topGap),
                        child: child,
                      );
                    },
                    childCount: finalItems.length,
                  ),
                ),
        ),
      ],
    );
  }
}

class HomeListItem {
  final String title;
  final String? villeId;
  final String? communeId;
  final bool isHeader;

  const HomeListItem({
    required this.title,
    this.villeId,
    this.communeId,
    this.isHeader = false,
  });
}

final List<HomeListItem> _homeItems = [
  // --- Section 1 : Villes populaires ---
  const HomeListItem(title: "VILLES POPULAIRES", isHeader: true),
  const HomeListItem(
      title: "Abidjan", villeId: "8b97b9ce-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Aboisso", villeId: "8b981afc-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Anyama", villeId: "8b9806f9-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Grand-Bassam", villeId: "8b981ba8-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Yamoussoukro", villeId: "8b97d0b3-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "San-Pédro", villeId: "8b97ea35-a507-11ef-8b44-0e595bc2ce41"),

  // --- Section 2 : Communes d'Abidjan ---
  const HomeListItem(
      title: "Abobo", communeId: "8bb4b211-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Adjamé", communeId: "55a42f68-2867-11f1-a056-661ac3bf2f34"),
  const HomeListItem(
      title: "Attécoubé", communeId: "8bb4d4d0-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Cocody", communeId: "8bb446ea-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Koumassi", communeId: "8bb4b588-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Marcory", communeId: "8bb498f3-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Plateau (Le Plateau)",
      communeId: "8bb48973-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Port-Bouët", communeId: "8bb4c15a-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Treichville", communeId: "8bb4a496-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Yopougon", communeId: "8bb47716-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Anyama (Commune)",
      communeId: "567aa860-2867-11f1-a056-661ac3bf2f34"),
  const HomeListItem(
      title: "Bingerville", communeId: "8bb68343-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Bonoua", communeId: "8bb80dca-a507-11ef-8b44-0e595bc2ce41"),

  // --- Section 3 : Villes extérieures ---
  const HomeListItem(
      title: "Abengourou", villeId: "8b980686-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Adzopé", villeId: "8b981bef-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Agboville", villeId: "8b981b46-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Bondoukou", villeId: "8b980e6a-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Bouaké", villeId: "8b97dccc-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Daloa", villeId: "8b97e49c-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Divo", villeId: "8b97f856-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Ferkessédougou", villeId: "8b980eb7-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Gagnoa", villeId: "8b97f23e-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Issia", villeId: "8b981c4e-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Korhogo", villeId: "8b97ea95-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Man", villeId: "8b97f0aa-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Odienné", villeId: "8b9814b6-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Séguéla", villeId: "8b981507-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Soubré", villeId: "8b980dd8-a507-11ef-8b44-0e595bc2ce41"),
  const HomeListItem(
      title: "Toumodi", villeId: "8b981aa6-a507-11ef-8b44-0e595bc2ce41"),
];

/// Placements dédiés (ex: RESIDENCE_LIST_YOPOUGON) pour les villes/communes
/// les plus populaires. Les autres localisations retombent sur le tag
/// générique RESIDENCE_LIST_ALL.
const Map<String, AdPlacement> _locationAdPlacements = {
  "8b97b9ce-a507-11ef-8b44-0e595bc2ce41": AdPlacement.residenceListAbidjan,
  "8b981afc-a507-11ef-8b44-0e595bc2ce41": AdPlacement.residenceListAboisso,
  "8b981ba8-a507-11ef-8b44-0e595bc2ce41": AdPlacement.residenceListGrandBassam,
  "8b97d0b3-a507-11ef-8b44-0e595bc2ce41": AdPlacement.residenceListYamoussoukro,
  "8b97ea35-a507-11ef-8b44-0e595bc2ce41": AdPlacement.residenceListSanPedro,
  "8bb446ea-a507-11ef-8b44-0e595bc2ce41": AdPlacement.residenceListCocody,
  "8bb47716-a507-11ef-8b44-0e595bc2ce41": AdPlacement.residenceListYopougon,
  "8bb48973-a507-11ef-8b44-0e595bc2ce41": AdPlacement.residenceListPlateau,
};

AdPlacement _adPlacementForLocation({String? villeId, String? communeId}) {
  final id = villeId ?? communeId;
  return _locationAdPlacements[id] ?? AdPlacement.residenceListAll;
}

/// Item synthétique représentant la pub dédiée d'une section (ex:
/// RESIDENCE_LIST_YOPOUGON), insérée juste après cette section dans
/// `finalItems` pour que l'espacement pub soit géré à un seul endroit.
class _LocationAdSlot {
  final AdPlacement placement;
  final AdType adType;
  const _LocationAdSlot(this.placement, this.adType);
}

/// Espace pub (haut/bas) à appliquer selon le type de la pub : le carrousel
/// a déjà son propre padding visuel, donc il a besoin de moins d'espace
/// que les autres formats (image/vidéo).
double _pubGapFor(dynamic item) {
  final AdType? type = item is AdCampaignModel
      ? AdType.fromString(item.type)
      : item is _LocationAdSlot
          ? item.adType
          : null;
  switch (type) {
    case AdType.carousel:
      return kHomeSectionPubCarrousel;
    case AdType.videoCarousel:
      return kHomeSectionPubCarrouselVideo;
    default:
      return kHomeSectionSpacingPub;
  }
}

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeSectionTitle(title: title),
            IconButton(
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
              icon: Icon(
                Iconsax.arrow_right_1,
                size: 20,
                color: residences.isNotEmpty ? Colors.black : Colors.grey.shade400,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
          ],
        ),
        const Gap(12),
        SizedBox(
          height: compactResidenceCardHeight,
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
  static const Color primary = kPrimaryColor;
  static const Color primary50 = Color(0xffEEF1FC);
  static const Color primary100 = Color(0xffC5CFF5);
  static const Color primary200 = Color(0xff9BADEF);
  static const Color primary300 = Color(0xff6B85E6);
  static const Color primary400 = Color(0xff4A64E2);
  static const Color primary600 = Color(0xff1E35B8);
  static const Color primary700 = Color(0xff182A92);
  static const Color primary800 = Color(0xff121F6C);
  static const Color primary900 = Color(0xff0C1446);
}
