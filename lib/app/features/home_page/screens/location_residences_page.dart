import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/residence_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LocationResidencesPage extends StatefulWidget {
  final String title;
  final String? villeId;
  final String? communeId;

  const LocationResidencesPage({
    super.key,
    required this.title,
    this.villeId,
    this.communeId,
  });

  static const String routePath = '/location-residences';
  static const String routeName = 'location-residences';

  @override
  State<LocationResidencesPage> createState() => _LocationResidencesPageState();
}

class _LocationResidencesPageState extends State<LocationResidencesPage> {
  final PagingController<int, ResidenceModel> _pagingController =
      PagingController(firstPageKey: 1);
  final ResidenceRepository _residenceRepository = getIt<ResidenceRepository>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_loadPage);
  }

  Future<void> _loadPage(int pageKey) async {
    try {
      final Map<String, dynamic> where = {};
      if (widget.villeId != null) {
        where['_villeId'] = widget.villeId;
      }
      if (widget.communeId != null) {
        where['_communeId'] = widget.communeId;
      }

      final result = await _residenceRepository.getResidences(
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
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
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
                    child: ResidenceCard(
                      residence: item,
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
