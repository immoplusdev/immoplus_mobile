import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:immoplus/app/data/enums/ad_placement.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/widgets/ads/ad_widget.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/constants/home_location_items.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_state.dart';
import 'package:immoplus/app/features/home_page/screens/estates_near_list.dart';
import 'package:immoplus/app/features/home_page/screens/location_biens_page.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_bien_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/empty_state_card.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class _Constants {
  static const int minBudgetPrice = 100000;
  static const int maxBudgetPrice = 350000;
  static const String budgetSectionTitle = "De 100.000 à 350.000 FCFA";
}

class EstatesList extends StatefulWidget {
  const EstatesList({super.key});

  @override
  State<EstatesList> createState() => _EstatesListState();
}

class _EstatesListState extends State<EstatesList> with ConnectivityMixin {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  final List<EstateSectionData> _displayList = [];
  bool _isBackgroundLoading = false;
  EstateSubCategory _lastSubCategory = FilterHandler.estateSubCategory;
  int _currentToken = 0;

  void _onPageRequest(int pageKey) => loadPage(pageKey);

  @override
  void onConnectionRestored() {
    if (_displayList.isEmpty && !_isBackgroundLoading) {
      _loadAllSectionsInBackground();
    }
  }

  Future<void> loadPage(int page) async {
    final whereFilters = FilterHandler.getAllFilters(PropertyType.estate);
    bienImmobilierRepository
        .getBiensImmobiliers(
      page: page,
      where: whereFilters,
      search: FilterHandler.search,
      lat: FilterHandler.lat,
      long: FilterHandler.long,
      startDate: FilterHandler.startDate,
      endDate: FilterHandler.endDate,
    )
        .then((value) {
      if (value.hasNext == true) {
        HomePageState.pagingControllerEstate
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        HomePageState.pagingControllerEstate.appendLastPage(value.data ?? []);
      }
    }).onError((error, stackTrace) {
      HomePageState.pagingControllerEstate.error = error.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    HomePageState.pagingControllerEstate.addPageRequestListener(_onPageRequest);
    HomePageState.pagingControllerEstate.refresh();
    FilterHandler.notifier.addListener(_onFilterChanged);
    _loadAllSectionsInBackground();
    setupConnectivityListener();
  }

  void _onFilterChanged() {
    if (!mounted) return;
    if (FilterHandler.estateSubCategory != _lastSubCategory) {
      _lastSubCategory = FilterHandler.estateSubCategory;
      _loadAllSectionsInBackground();
    }
  }

  @override
  void dispose() {
    FilterHandler.notifier.removeListener(_onFilterChanged);
    disposeConnectivityListener();
    HomePageState.pagingControllerEstate
        .removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  Map<String, dynamic> _buildPriceWhere({
    required Map<String, dynamic> baseFilters,
    required int minPrice,
    required int maxPrice,
  }) {
    final where = <String, dynamic>{...baseFilters};
    final whereList =
        List<String>.from(where['_where'] as List<String>? ?? const []);
    whereList.addAll([
      '{"_field": "prix", "_op": "gte", "_val": "$minPrice"}',
      '{"_field": "prix", "_op": "lte", "_val": "$maxPrice"}',
    ]);
    where['_where'] = whereList;
    return where;
  }

  Future<void> _loadAllSectionsInBackground() async {
    if (!mounted) return;
    final int token = ++_currentToken;
    final activeSubCat = FilterHandler.estateSubCategory;

    setState(() {
      _isBackgroundLoading = true;
      _displayList.clear();
    });

    try {
      final defaultFilters = FilterHandler.getAllFilters(PropertyType.estate);

      // --- 1. Section Budget : "De 100.000 à 350.000 FCFA" ---
      final priceWhere = _buildPriceWhere(
        baseFilters: defaultFilters,
        minPrice: _Constants.minBudgetPrice,
        maxPrice: _Constants.maxBudgetPrice,
      );

      try {
        final priceResult = await bienImmobilierRepository.getBiensImmobiliers(
          page: 1,
          perPage: 10,
          where: priceWhere,
        );
        if (!mounted || token != _currentToken) return;

        final priceBiens = priceResult.data ?? [];
        if (priceBiens.isNotEmpty) {
          setState(() {
            _displayList.add(
              EstateSectionData(
                title: _Constants.budgetSectionTitle,
                minPrice: _Constants.minBudgetPrice,
                maxPrice: _Constants.maxBudgetPrice,
                subCategory: activeSubCat,
                biens: priceBiens,
              ),
            );
          });
        }
      } catch (e) {
        debugPrint('Error loading price section (100k-350k): $e');
      }

      if (!mounted || token != _currentToken) return;

      // --- 2. Sections par Ville / Commune ---
      final itemsToLoad =
          kHomeLocationItems.where((item) => !item.isHeader).toList();
      const int batchSize = 2; // Fetch in light batches of 2 in background

      for (int i = 0; i < itemsToLoad.length; i += batchSize) {
        if (!mounted || token != _currentToken) break;
        final batch = itemsToLoad.sublist(
            i,
            i + batchSize > itemsToLoad.length
                ? itemsToLoad.length
                : i + batchSize);

        final futures = batch.map((item) async {
          final Map<String, dynamic> where = {...defaultFilters};
          if (item.villeId != null) {
            where['_villeId'] = item.villeId;
          }
          if (item.communeId != null) {
            where['_communeId'] = item.communeId;
          }

          try {
            final result = await bienImmobilierRepository.getBiensImmobiliers(
              page: 1,
              perPage: 10,
              where: where,
            );
            final list = result.data ?? [];
            if (list.isNotEmpty) {
              return EstateSectionData(
                title: item.title,
                villeId: item.villeId,
                communeId: item.communeId,
                subCategory: activeSubCat,
                biens: list,
              );
            }
          } catch (e) {
            debugPrint('Error loading estate section ${item.title}: $e');
          }
          return null;
        }).toList();

        final results = await Future.wait(futures);
        if (!mounted || token != _currentToken) break;

        final List<EstateSectionData> loadedSections = [];
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
      if (mounted && token == _currentToken) {
        setState(() {
          _isBackgroundLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adsState = context.watch<AdsCubit>().state;
    final ads = adsState.maybeWhen(
      success: (list) => list
          .where((c) => c.placement == AdPlacement.locationList.value)
          .toList(),
      orElse: () => <AdCampaignModel>[],
    );

    // Merge ads into the section list based on positionIndex
    final List<dynamic> listItems = [..._displayList];
    final indexedAds = ads.where((ad) => ad.positionIndex != null).toList()
      ..sort((a, b) => a.positionIndex!.compareTo(b.positionIndex!));

    int insertedCount = 0;
    for (final ad in indexedAds) {
      final target = ad.positionIndex! +
          1 +
          insertedCount; // "after the N-th element" (0-based)
      if (target >= 0 && target <= listItems.length) {
        listItems.insert(target, ad);
        insertedCount++;
      }
    }

    return MultiSliver(
      children: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: AdWidget(placement: AdPlacement.propertyListTop),
          ),
        ),
        BlocBuilder<LocationPermissionCubit, LocationPermissionState>(
          builder: (context, permissionState) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ValueListenableBuilder<int>(
                  valueListenable: FilterHandler.notifier,
                  builder: (context, _, __) {
                    if (FilterHandler.search != null &&
                        FilterHandler.search!.isNotEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (permissionState.isGranted ||
                        FilterHandler.lat != null) {
                      return const EstatesNearList();
                    }
                    return const SizedBox.shrink();
                  },
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
                                separatorBuilder: (context, index) =>
                                    const Gap(12),
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
              : _displayList.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 30),
                        child: EmptyStateCard(
                          imagePath: 'assets/img/modal/image.png',
                          title: 'Aucun bien disponible',
                          subtitle: FilterHandler.estateSubCategory !=
                                  EstateSubCategory.all
                              ? 'Aucun bien de type "${FilterHandler.estateSubCategory.label}" n\'est disponible en location pour le moment.'
                              : 'Aucun bien n\'est disponible en location pour le moment.',
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = listItems[index];
                          if (item is AdCampaignModel) {
                            return AdWidget(
                              placement: AdPlacement.locationList,
                              index: item.positionIndex,
                            );
                          }
                          final section = item as EstateSectionData;
                          return EstatesHorizontalSectionWidget(
                            key: ValueKey(
                                'estate_section_${section.minPrice ?? section.villeId ?? section.communeId}_${section.title}'),
                            section: section,
                          );
                        },
                        childCount: listItems.length,
                      ),
                    ),
        ),
      ],
    );
  }
}

class EstatesHorizontalSectionWidget extends StatelessWidget {
  final EstateSectionData section;

  const EstatesHorizontalSectionWidget({
    super.key,
    required this.section,
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
            HomeSectionTitle(title: section.title),
            IconButton(
              onPressed: section.biens.isNotEmpty
                  ? () {
                      context.push(
                        LocationBiensPage.routePath,
                        extra: {
                          'title': section.title,
                          'villeId': section.villeId,
                          'communeId': section.communeId,
                          'minPrice': section.minPrice,
                          'maxPrice': section.maxPrice,
                          'propertyType': PropertyType.estate,
                          'subCategory': section.subCategory ??
                              FilterHandler.estateSubCategory,
                        },
                      );
                    }
                  : null,
              icon: Icon(
                Iconsax.arrow_right_1,
                size: 20,
                color: section.biens.isNotEmpty
                    ? Colors.black
                    : Colors.grey.shade400,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
          ],
        ),
        const Gap(12),
        SizedBox(
          height: 255,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: section.biens.length,
            separatorBuilder: (context, index) => const Gap(12),
            itemBuilder: (context, index) {
              return CompactBienCard(bien: section.biens[index]);
            },
          ),
        ),
      ],
    );
  }
}

class EstateSectionData {
  final String title;
  final String? villeId;
  final String? communeId;
  final int? minPrice;
  final int? maxPrice;
  final EstateSubCategory? subCategory;
  final List<BienImmobilierModel> biens;

  EstateSectionData({
    required this.title,
    this.villeId,
    this.communeId,
    this.minPrice,
    this.maxPrice,
    this.subCategory,
    required this.biens,
  });
}
