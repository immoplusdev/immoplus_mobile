import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReductionResidencesPage extends StatefulWidget {
  const ReductionResidencesPage({super.key});

  static const String routePath = '/reduction-residences';
  static const String routeName = 'reduction-residences';

  @override
  State<ReductionResidencesPage> createState() =>
      _ReductionResidencesPageState();
}

class _ReductionResidencesPageState extends State<ReductionResidencesPage> {
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
      final result = await _residenceRepository.getResidences(
        page: pageKey,
        where: {
          '_where': [
            '{"_field": "reduction", "_op": "gt", "_val": 0}',
          ],
        },
      );

      // Filtre de sécurité côté client : certains environnements API
      // renvoient encore des résidences sans réduction malgré le `_where`,
      // donc on ne garde que celles ayant réellement reduction > 0.
      final reduced = (result.data ?? []).where((r) => r.hasReduction).toList();

      if (result.hasNext == true) {
        _pagingController.appendPage(
          reduced,
          (result.currentPage ?? 0) + 1,
        );
      } else {
        _pagingController.appendLastPage(reduced);
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
          'Réductions',
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
                            Icons.local_offer_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const Gap(20),
                          Text(
                            "Aucune réduction en cours",
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
                        'Vous avez vu toutes les résidences en réduction',
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
