import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/constants/home_location_items.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/home_page/screens/location_biens_page.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_bien_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Sections horizontales "par ville" pour les biens immobiliers (utilisé par
/// les onglets Locations [PropertyType.estate, aLouer:true] et Biens
/// [PropertyType.land, aLouer:false]). Remplace l'ancienne liste verticale
/// filtrée pour ces deux onglets, comme fait précédemment pour Résidences.
class BienLocationSectionsList extends StatefulWidget {
  final PropertyType propertyType;

  /// Ancien PagingController conservé pour compatibilité avec le
  /// rafraîchissement générique déclenché depuis home_page.dart
  /// (HomePageState.getPageListController(index).refresh()).
  final PagingController<int, BienImmobilierModel> legacyPagingController;

  const BienLocationSectionsList({
    super.key,
    required this.propertyType,
    required this.legacyPagingController,
  });

  @override
  State<BienLocationSectionsList> createState() =>
      _BienLocationSectionsListState();
}

class _BienLocationSectionsListState extends State<BienLocationSectionsList> {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();

  bool _isParentLoading = true;
  List<BienLocationSectionData> _activeSections = [];
  List<BienLocationSectionData> _displayList = [];

  void _onPageRequest(int pageKey) => loadPage(pageKey);

  Future<void> loadPage(int page) async {
    final whereFilters = FilterHandler.getAllFilters(widget.propertyType);
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
    _loadAllSections();
  }

  @override
  void dispose() {
    widget.legacyPagingController.removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  Future<void> _loadAllSections() async {
    if (!mounted) return;
    setState(() {
      _isParentLoading = true;
    });

    try {
      final defaultFilters = FilterHandler.getAllFilters(widget.propertyType);

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
          final result = await bienImmobilierRepository.getBiensImmobiliers(
            page: 1,
            perPage: 10,
            where: where,
          );
          final list = result.data ?? [];
          return BienLocationSectionData(
            title: item.title,
            villeId: item.villeId,
            communeId: item.communeId,
            biens: list,
          );
        } catch (e) {
          debugPrint('Error loading section ${item.title}: $e');
        }
        return null;
      }).toList();

      final results = await Future.wait(futures);

      final List<BienLocationSectionData> active = [];
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

  List<BienLocationSectionData> _buildDisplayList() {
    final List<BienLocationSectionData> list = [];
    for (var item in kHomeLocationItems) {
      if (item.isHeader) continue;

      final loaded = _activeSections
          .cast<BienLocationSectionData?>()
          .firstWhere(
            (s) =>
                s != null &&
                s.villeId == item.villeId &&
                s.communeId == item.communeId,
            orElse: () => null,
          );
      final isLoad = loaded != null && loaded.biens.isNotEmpty;

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
                  return BiensHorizontalListByLocation(
                    key: ValueKey(
                        '${widget.propertyType.name}_location_${item.villeId ?? item.communeId}'),
                    title: item.title,
                    villeId: item.villeId,
                    communeId: item.communeId,
                    biens: item.biens,
                    propertyType: widget.propertyType,
                  );
                },
                childCount: _displayList.length,
              ),
            ),
    );
  }
}

class BiensHorizontalListByLocation extends StatelessWidget {
  final String title;
  final String? villeId;
  final String? communeId;
  final List<BienImmobilierModel> biens;
  final PropertyType propertyType;

  const BiensHorizontalListByLocation({
    super.key,
    required this.title,
    this.villeId,
    this.communeId,
    required this.biens,
    required this.propertyType,
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
                          'villeId': villeId,
                          'communeId': communeId,
                          'propertyType': propertyType,
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
        if (biens.isEmpty)
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
                  "Aucun bien disponible dans cette localité",
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

class BienLocationSectionData {
  final String title;
  final String? villeId;
  final String? communeId;
  final List<BienImmobilierModel> biens;

  BienLocationSectionData({
    required this.title,
    this.villeId,
    this.communeId,
    required this.biens,
  });
}
