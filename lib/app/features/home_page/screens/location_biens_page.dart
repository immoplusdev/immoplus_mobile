import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class LocationBiensPage extends StatefulWidget {
  final String title;
  final String? villeId;
  final String? communeId;
  final EstateSubCategory? subCategory;
  final PropertyType propertyType;
  final double? lat;
  final double? long;
  final double? radius;
  final int? minPrice;
  final int? maxPrice;

  const LocationBiensPage({
    super.key,
    required this.title,
    this.villeId,
    this.communeId,
    this.subCategory,
    this.propertyType = PropertyType.land,
    this.lat,
    this.long,
    this.radius,
    this.minPrice,
    this.maxPrice,
  });

  static const String routePath = '/location-biens';
  static const String routeName = 'location-biens';

  @override
  State<LocationBiensPage> createState() => _LocationBiensPageState();
}

class _LocationBiensPageState extends State<LocationBiensPage>
    with ConnectivityMixin {
  final PagingController<int, BienImmobilierModel> _pagingController =
      PagingController(firstPageKey: 1);
  final BienImmobilierRepository _bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  @override
  void onConnectionRestored() {
    if (_pagingController.itemList == null ||
        _pagingController.itemList!.isEmpty) {
      _pagingController.error = 'temporary_error_to_force_refresh';
      _pagingController.refresh();
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_loadPage);
    setupConnectivityListener();
  }

  bool get _isGeolocalized =>
      widget.lat != null && widget.long != null && widget.radius != null;

  Future<void> _loadPage(int pageKey) async {
    try {
      if (_isGeolocalized) {
        await _loadGeolocalizedBiens(pageKey);
      } else {
        await _loadFilteredBiens(pageKey);
      }
    } catch (error) {
      showConnectionErrorDialog();
    }
  }

  Future<void> _loadGeolocalizedBiens(int pageKey) async {
    final where = _buildWhereFilters();
    final result = await _bienImmobilierRepository.getBiensLocalized(
      page: pageKey,
      lat: widget.lat!,
      long: widget.long!,
      radius: widget.radius,
      perPage: 10,
      where: where,
    );
    _appendResultToPaging(result);
  }

  Future<void> _loadFilteredBiens(int pageKey) async {
    final where = _buildWhereFilters(
      villeId: widget.villeId,
      communeId: widget.communeId,
      minPrice: widget.minPrice,
      maxPrice: widget.maxPrice,
    );
    final result = await _bienImmobilierRepository.getBiensImmobiliers(
      page: pageKey,
      where: where,
    );
    _appendResultToPaging(result);
  }

  Map<String, dynamic> _buildWhereFilters({
    String? villeId,
    String? communeId,
    int? minPrice,
    int? maxPrice,
  }) {
    final where = <String, dynamic>{
      ...FilterHandler.getAllFilters(widget.propertyType),
    };
    if (villeId != null) {
      where['_villeId'] = villeId;
    }
    if (communeId != null) {
      where['_communeId'] = communeId;
    }

    final whereList =
        List<String>.from(where['_where'] as List<String>? ?? const []);

    if (widget.subCategory != null &&
        widget.subCategory != EstateSubCategory.all &&
        widget.subCategory!.value != null) {
      final typeFilter =
          '{"_field": "typeBienImmobilier", "_op": "eq", "_val": "${widget.subCategory!.value}"}';
      if (!whereList.contains(typeFilter)) {
        whereList.add(typeFilter);
      }
    }

    if (minPrice != null) {
      whereList.add('{"_field": "prix", "_op": "gte", "_val": "$minPrice"}');
    }
    if (maxPrice != null) {
      whereList.add('{"_field": "prix", "_op": "lte", "_val": "$maxPrice"}');
    }

    where['_where'] = whereList;
    return where;
  }

  void _appendResultToPaging(dynamic result) {
    if (result.hasNext == true) {
      _pagingController.appendPage(
        result.data ?? [],
        (result.currentPage ?? 0) + 1,
      );
    } else {
      _pagingController.appendLastPage(result.data ?? []);
    }
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            const SliverGap(10),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: PagedSliverList<int, BienImmobilierModel>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  firstPageProgressIndicatorBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: List.generate(
                        10,
                        (index) => LoadProductCard(),
                      ),
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const Gap(20),
                          Text(
                            "Aucun bien trouvé",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  noMoreItemsIndicatorBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Vous avez vu tous les biens',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, item, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1)
                        .copyWith(bottom: 13),
                    child: UnifiedPropertyCard(
                      item: item,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
