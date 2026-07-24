import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/constants/home_location_items.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/home_page/screens/location_biens_page.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_bien_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class BienLocationSectionsList extends StatefulWidget {
  final PropertyType propertyType;
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

class _BienLocationSectionsListState extends State<BienLocationSectionsList>
    with ConnectivityMixin {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  final List<_BienLocationSectionData> _displayList = [];
  bool _isBackgroundLoading = false;

  void _onPageRequest(int pageKey) => loadPage(pageKey);

  @override
  void onConnectionRestored() {
    if (_displayList.isEmpty && !_isBackgroundLoading) {
      _loadAllSectionsInBackground();
    }
  }

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
    _loadAllSectionsInBackground();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    widget.legacyPagingController.removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  Future<void> _loadAllSectionsInBackground() async {
    if (!mounted) return;
    setState(() {
      _isBackgroundLoading = true;
      _displayList.clear();
    });

    try {
      final defaultFilters = FilterHandler.getAllFilters(widget.propertyType);
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
            final result = await bienImmobilierRepository.getBiensImmobiliers(
              page: 1,
              perPage: 10,
              where: where,
            );
            final list = result.data ?? [];
            if (list.isNotEmpty) {
              return _BienLocationSectionData(
                title: item.title,
                villeId: item.villeId,
                communeId: item.communeId,
                biens: list,
              );
            }
          } catch (e) {
            debugPrint('Error loading section ${item.title}: $e');
          }
          return null;
        }).toList();

        final results = await Future.wait(futures);
        if (!mounted) break;

        final List<_BienLocationSectionData> loadedSections = [];
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
      sliver: SliverList(
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

class _BienLocationSectionData {
  final String title;
  final String? villeId;
  final String? communeId;
  final List<BienImmobilierModel> biens;

  _BienLocationSectionData({
    required this.title,
    this.villeId,
    this.communeId,
    required this.biens,
  });
}
