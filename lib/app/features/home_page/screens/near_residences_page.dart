import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/home_page/screens/residences_near_list.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NearResidencesPage extends StatefulWidget {
  const NearResidencesPage({
    super.key,
    required this.latitude,
    required this.longitude,
    this.radius = NearResidencesConstants.defaultRadius,
  });

  // Constantes pour éviter les magic values
  static const String routePath = '/near-residences';
  static const String routeName = 'near-residences';

  final double latitude;
  final double longitude;
  final double radius;

  @override
  State<NearResidencesPage> createState() => _NearResidencesPageState();
}

class _NearResidencesPageState extends State<NearResidencesPage> {
  final PagingController<int, ResidenceModel> _pagingController =
      PagingController(firstPageKey: 1);
  final ResidenceRepository _residenceRepository = getIt<ResidenceRepository>();

  @override
  void initState() {
    super.initState();
    getIt<AnalyticsService>().logNearResidencesViewed();
    _pagingController.addPageRequestListener(_loadPage);
  }

  Future<void> _loadPage(int pageKey) async {
    try {
      final result = await _residenceRepository.getResidences(
        lat: widget.latitude,
        long: widget.longitude,
        radius: widget.radius,
        page: pageKey,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Près De Vous',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            Text(
              'Résidences dans un rayon de ${widget.radius.toInt()} km',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
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
              sliver: PagedSliverList<int, ResidenceModel>(
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
                            "Aucune résidence trouvée",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Gap(10),
                          Text(
                            "Il n'y a pas de résidences dans un rayon de ${widget.radius.toInt()} km",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  noMoreItemsIndicatorBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Vous avez vu toutes les résidences',
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
