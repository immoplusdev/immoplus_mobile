import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LocationFurnituresPage extends StatefulWidget {
  final String title;
  final String? villeId;
  final String? communeId;

  const LocationFurnituresPage({
    super.key,
    required this.title,
    this.villeId,
    this.communeId,
  });

  static const String routePath = '/location-furnitures';
  static const String routeName = 'location-furnitures';

  @override
  State<LocationFurnituresPage> createState() =>
      _LocationFurnituresPageState();
}

class _LocationFurnituresPageState extends State<LocationFurnituresPage> {
  final PagingController<int, FurnitureModel> _pagingController =
      PagingController(firstPageKey: 1);
  final FurnitureRepository _furnitureRepository = getIt<FurnitureRepository>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_loadPage);
  }

  Future<void> _loadPage(int pageKey) async {
    try {
      final Map<String, dynamic> where = {
        ...FilterHandler.getAllFilters(PropertyType.furniture),
      };
      if (widget.villeId != null) {
        where['_villeId'] = widget.villeId;
      }
      if (widget.communeId != null) {
        where['_communeId'] = widget.communeId;
      }

      final result = await _furnitureRepository.getFurnitures(
        page: pageKey,
        where: where,
      );

      if (result.hasNext == true) {
        _pagingController.appendPage(
          result.data ?? [],
          (result.currentPage ?? 0) + 1,
        );
      } else {
        _pagingController.appendLastPage(result.data ?? []);
      }
    } catch (error) {
      _pagingController.error = error.toString();
    }
  }

  @override
  void dispose() {
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
              sliver: PagedSliverList<int, FurnitureModel>(
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
                            "Aucun meuble trouvé",
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
                        'Vous avez vu tous les meubles',
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
