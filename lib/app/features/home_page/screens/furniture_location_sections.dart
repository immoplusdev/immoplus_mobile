import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/constants/home_location_items.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/screens/location_furnitures_page.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_furniture_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

/// Sections horizontales "par ville" pour les meubles, sur le même principe
/// que BienLocationSectionsList (résidences, locations, biens).
class FurnitureLocationSectionsList extends StatefulWidget {
  const FurnitureLocationSectionsList({super.key});

  @override
  State<FurnitureLocationSectionsList> createState() =>
      _FurnitureLocationSectionsListState();
}

class _FurnitureLocationSectionsListState
    extends State<FurnitureLocationSectionsList> with ConnectivityMixin {
  final FurnitureRepository furnitureRepository = getIt<FurnitureRepository>();

  bool _isParentLoading = true;
  List<FurnitureLocationSectionData> _activeSections = [];
  List<FurnitureLocationSectionData> _displayList = [];

  void _onPageRequest(int pageKey) => loadPage(pageKey);

  @override
  void onConnectionRestored() {
    if (_activeSections.isEmpty) {
      _loadAllSections();
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
    _loadAllSections();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    HomePageState.pagingControllerFurniture
        .removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  Future<void> _loadAllSections() async {
    if (!mounted) return;
    setState(() {
      _isParentLoading = true;
    });

    try {
      final defaultFilters =
          FilterHandler.getAllFilters(PropertyType.furniture);

      final futures = kHomeLocationItems.map((item) async {
        if (item.isHeader) return null;

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
          return FurnitureLocationSectionData(
            title: item.title,
            villeId: item.villeId,
            communeId: item.communeId,
            furnitures: list,
          );
        } catch (e) {
          debugPrint('Error loading section ${item.title}: $e');
          rethrow;
        }
      }).toList();

      final results = await Future.wait(futures);

      final List<FurnitureLocationSectionData> active = [];
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
        showConnectionErrorDialog();
      }
    }
  }

  List<FurnitureLocationSectionData> _buildDisplayList() {
    final List<FurnitureLocationSectionData> list = [];
    for (var item in kHomeLocationItems) {
      if (item.isHeader) continue;

      final loaded =
          _activeSections.cast<FurnitureLocationSectionData?>().firstWhere(
                (s) =>
                    s != null &&
                    s.villeId == item.villeId &&
                    s.communeId == item.communeId,
                orElse: () => null,
              );
      final isLoad = loaded != null && loaded.furnitures.isNotEmpty;

      if (isLoad) {
        list.add(loaded);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: _isParentLoading
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
        if (furnitures.isEmpty)
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
                  "Aucun meuble disponible dans cette localité",
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

class FurnitureLocationSectionData {
  final String title;
  final String? villeId;
  final String? communeId;
  final List<FurnitureModel> furnitures;

  FurnitureLocationSectionData({
    required this.title,
    this.villeId,
    this.communeId,
    required this.furnitures,
  });
}
