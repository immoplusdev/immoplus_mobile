import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/features/home_page/screens/location_biens_page.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_bien_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Sections horizontales "par sous-catégorie" pour l'onglet Locations
/// (PropertyType.estate, aLouer:true) : Appartements, Villas, Studios, Duplex.
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
    extends State<EstateSubCategorySectionsList> {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();

  bool _isParentLoading = true;
  List<EstateSubCategorySectionData> _displayList = [];

  void _onPageRequest(int pageKey) => loadPage(pageKey);

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
    _loadAllSections();
  }

  @override
  void dispose() {
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

  Future<void> _loadAllSections() async {
    if (!mounted) return;
    setState(() {
      _isParentLoading = true;
    });

    try {
      final defaultFilters = FilterHandler.getAllFilters(PropertyType.estate);

      final futures = _kEstateSubCategorySections.map((section) async {
        final where = _buildWhereForCategory(defaultFilters, section.category);

        try {
          final result = await bienImmobilierRepository.getBiensImmobiliers(
            page: 1,
            perPage: 10,
            where: where,
          );
          return EstateSubCategorySectionData(
            title: section.title,
            category: section.category,
            biens: result.data ?? [],
          );
        } catch (e) {
          debugPrint('Error loading section ${section.title}: $e');
        }
        return null;
      }).toList();

      final results = await Future.wait(futures);

      final List<EstateSubCategorySectionData> active = [];
      for (var r in results) {
        if (r != null && r.biens.isNotEmpty) {
          active.add(r);
        }
      }

      if (mounted) {
        setState(() {
          _displayList = active;
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
                  return BiensHorizontalListBySubCategory(
                    key: ValueKey('estate_subcategory_${item.category.name}'),
                    title: item.title,
                    category: item.category,
                    biens: item.biens,
                  );
                },
                childCount: _displayList.length,
              ),
            ),
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
                  "Aucun bien disponible dans cette catégorie",
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

class EstateSubCategorySectionData {
  final String title;
  final EstateSubCategory category;
  final List<BienImmobilierModel> biens;

  EstateSubCategorySectionData({
    required this.title,
    required this.category,
    required this.biens,
  });
}
