import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/constants/home_location_items.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/screens/location_furnitures_page.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_furniture_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class FurnitureLocationSectionsList extends StatefulWidget {
  const FurnitureLocationSectionsList({super.key});

  @override
  State<FurnitureLocationSectionsList> createState() =>
      _FurnitureLocationSectionsListState();
}

class _FurnitureLocationSectionsListState
    extends State<FurnitureLocationSectionsList> with ConnectivityMixin {
  final FurnitureRepository furnitureRepository = getIt<FurnitureRepository>();
  final List<_FurnitureLocationSectionData> _displayList = [];
  bool _isBackgroundLoading = false;

  void _onPageRequest(int pageKey) => loadPage(pageKey);

  @override
  void onConnectionRestored() {
    if (_displayList.isEmpty && !_isBackgroundLoading) {
      _loadAllSectionsInBackground();
    }
  }

  Future<void> loadPage(int page) async {
    final whereFilters = FilterHandler.getAllFilters(PropertyType.furniture);
    furnitureRepository
        .getFurnitures(
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
    HomePageState.pagingControllerFurniture
        .addPageRequestListener(_onPageRequest);
    HomePageState.pagingControllerFurniture.refresh();
    _loadAllSectionsInBackground();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    HomePageState.pagingControllerFurniture
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
      final defaultFilters =
          FilterHandler.getAllFilters(PropertyType.furniture);
      final itemsToLoad =
          kHomeLocationItems.where((item) => !item.isHeader).toList();
      const int batchSize = 2; // Fetch in light batches of 2 in background

      for (int i = 0; i < itemsToLoad.length; i += batchSize) {
        if (!mounted) break;
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
            final result = await furnitureRepository.getFurnitures(
              page: 1,
              perPage: 10,
              where: where,
            );
            final list = result.data ?? [];
            if (list.isNotEmpty) {
              return _FurnitureLocationSectionData(
                title: item.title,
                villeId: item.villeId,
                communeId: item.communeId,
                furnitures: list,
              );
            }
          } catch (e) {
            debugPrint('Error loading section ${item.title}: $e');
          }
          return null;
        }).toList();

        final results = await Future.wait(futures);
        if (!mounted) break;

        final List<_FurnitureLocationSectionData> loadedSections = [];
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
    return SliverPadding(
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
                  final item = _displayList[index];
                  return FurnituresHorizontalListByLocation(
                    key: ValueKey(
                        'location_furnitures_${item.villeId ?? item.communeId}'),
                    title: item.title,
                    villeId: item.villeId,
                    communeId: item.communeId,
                    furnitures: item.furnitures,
                  );
                },
                childCount: _displayList.length,
              ),
            ),
    );
  }
}

class FurnituresHorizontalListByLocation extends StatelessWidget {
  final String title;
  final String? villeId;
  final String? communeId;
  final List<FurnitureModel> furnitures;

  const FurnituresHorizontalListByLocation({
    super.key,
    required this.title,
    this.villeId,
    this.communeId,
    required this.furnitures,
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
              onPressed: furnitures.isNotEmpty
                  ? () {
                      context.push(
                        LocationFurnituresPage.routePath,
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
                color:
                    furnitures.isNotEmpty ? Colors.black : Colors.grey.shade400,
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
            itemCount: furnitures.length,
            separatorBuilder: (context, index) => const Gap(12),
            itemBuilder: (context, index) {
              return CompactFurnitureCard(furniture: furnitures[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _FurnitureLocationSectionData {
  final String title;
  final String? villeId;
  final String? communeId;
  final List<FurnitureModel> furnitures;

  _FurnitureLocationSectionData({
    required this.title,
    this.villeId,
    this.communeId,
    required this.furnitures,
  });
}
