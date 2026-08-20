import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:immoplus/app/data/enums/ad_placement.dart';
import 'package:immoplus/app/widgets/ads/ad_widget.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/features/home_page/screens/location_biens_page.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_bien_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class _SubCategorySection {
  final String title;
  final EstateSubCategory category;
  const _SubCategorySection(this.title, this.category);
}

const List<_SubCategorySection> _kEstateSubCategorySections = [
  _SubCategorySection('Appartements', EstateSubCategory.appartement),
  _SubCategorySection('Villas', EstateSubCategory.villa),
  _SubCategorySection('Studios', EstateSubCategory.studio),
  _SubCategorySection('Duplex', EstateSubCategory.duplex),
];

class EstateSubCategorySectionsList extends StatefulWidget {
  final PagingController<int, BienImmobilierModel> legacyPagingController;

  const EstateSubCategorySectionsList({
    super.key,
    required this.legacyPagingController,
  });

  @override
  State<EstateSubCategorySectionsList> createState() =>
      _EstateSubCategorySectionsListState();
}

class _EstateSubCategorySectionsListState
    extends State<EstateSubCategorySectionsList> with ConnectivityMixin {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  final List<_EstateSubCategorySectionData> _displayList = [];
  bool _isBackgroundLoading = false;

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
        widget.legacyPagingController
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        widget.legacyPagingController.appendLastPage(value.data ?? []);
      }
    }).onError((error, stackTrace) {
      widget.legacyPagingController.error = error.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    widget.legacyPagingController.addPageRequestListener(_onPageRequest);
    widget.legacyPagingController.refresh();
    _loadAllSectionsInBackground();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    widget.legacyPagingController.removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  Map<String, dynamic> _buildWhereForCategory(
    Map<String, dynamic> defaultFilters,
    EstateSubCategory category,
  ) {
    final where = <String, dynamic>{...defaultFilters};
    final whereList =
        List<String>.from(where['_where'] as List<String>? ?? const []);
    whereList.add(
      '{"_field": "typeBienImmobilier", "_op": "eq", "_val": "${category.value}"}',
    );
    where['_where'] = whereList;
    return where;
  }

  Future<void> _loadAllSectionsInBackground() async {
    if (!mounted) return;
    setState(() {
      _isBackgroundLoading = true;
      _displayList.clear();
    });

    try {
      final defaultFilters = FilterHandler.getAllFilters(PropertyType.estate);
      const int batchSize = 2; // Fetch in light batches of 2 in background

      for (int i = 0; i < _kEstateSubCategorySections.length; i += batchSize) {
        if (!mounted) break;
        final batch = _kEstateSubCategorySections.sublist(
            i,
            i + batchSize > _kEstateSubCategorySections.length
                ? _kEstateSubCategorySections.length
                : i + batchSize);

        final futures = batch.map((section) async {
          final where =
              _buildWhereForCategory(defaultFilters, section.category);

          try {
            final result = await bienImmobilierRepository.getBiensImmobiliers(
              page: 1,
              perPage: 10,
              where: where,
            );
            final list = result.data ?? [];
            if (list.isNotEmpty) {
              return _EstateSubCategorySectionData(
                title: section.title,
                category: section.category,
                biens: list,
              );
            }
          } catch (e) {
            debugPrint('Error loading subcategory ${section.title}: $e');
          }
          return null;
        }).toList();

        final results = await Future.wait(futures);
        if (!mounted) break;

        final List<_EstateSubCategorySectionData> loadedSections = [];
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
                  final item = listItems[index];
                  if (item is AdCampaignModel) {
                    return AdWidget(
                      placement: AdPlacement.locationList,
                      index: item.positionIndex,
                    );
                  }
                  final section = item as _EstateSubCategorySectionData;
                  return BiensHorizontalListBySubCategory(
                    key:
                        ValueKey('estate_subcategory_${section.category.name}'),
                    title: section.title,
                    category: section.category,
                    biens: section.biens,
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

class BiensHorizontalListBySubCategory extends StatelessWidget {
  final String title;
  final EstateSubCategory category;
  final List<BienImmobilierModel> biens;

  const BiensHorizontalListBySubCategory({
    super.key,
    required this.title,
    required this.category,
    required this.biens,
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
            IconButton(
              onPressed: biens.isNotEmpty
                  ? () {
                      context.push(
                        LocationBiensPage.routePath,
                        extra: {
                          'title': title,
                          'subCategory': category,
                          'propertyType': PropertyType.estate,
                        },
                      );
                    }
                  : null,
              icon: Icon(
                Iconsax.arrow_right_1,
                size: 20,
                color: biens.isNotEmpty ? Colors.black : Colors.grey.shade400,
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
            itemCount: biens.length,
            separatorBuilder: (context, index) => const Gap(12),
            itemBuilder: (context, index) {
              return CompactBienCard(bien: biens[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _EstateSubCategorySectionData {
  final String title;
  final EstateSubCategory category;
  final List<BienImmobilierModel> biens;

  _EstateSubCategorySectionData({
    required this.title,
    required this.category,
    required this.biens,
  });
}
