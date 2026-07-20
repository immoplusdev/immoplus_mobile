import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/rating/rating_model.dart';
import 'package:immoplus/app/data/repositories/rating_repository.dart';
import 'package:immoplus/app/features/rating/widgets/rating_history_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class RatingHistoryPage extends StatefulWidget {
  const RatingHistoryPage({super.key});
  
  static String name = 'RATING_HISTORY';
  static String routePath() => '/rating-history';

  @override
  State<RatingHistoryPage> createState() => _RatingHistoryPageState();
}

class _RatingHistoryPageState extends State<RatingHistoryPage> with ConnectivityMixin {
  final PagingController<int, RatingModel> _pagingController = PagingController(firstPageKey: 1);
  final RatingRepository ratingRepository = getIt<RatingRepository>();

  @override
  void onConnectionRestored() {
    if (_pagingController.itemList == null || _pagingController.itemList!.isEmpty) {
      _pagingController.error = 'temporary_error_to_force_refresh';
      _pagingController.refresh();
    }
  }

  Future<void> loadPage(int page) async {
    try {
      final value = await ratingRepository.getRatingHistory(
        page: page,
        perPage: 10,
      );
      if (value.hasNext == true) {
        _pagingController.appendPage(value.data, value.currentPage + 1);
      } else {
        _pagingController.appendLastPage(value.data);
      }
    } catch (e) {
      showConnectionErrorDialog();
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
    setupConnectivityListener();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Historique des notes'),
        backgroundColor: AppColors.whiteBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, size: 24),
          onPressed: () => context.canPop() ? context.pop() : context.go('/account'),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                _pagingController.refresh();
              },
            ),
            const SliverGap(15),
            PagedSliverList<int, RatingModel>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                firstPageProgressIndicatorBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                noItemsFoundIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(80),
                      SvgPicture.asset(
                        "assets/svgs/undraw/4.svg",
                        width: 200,
                      ),
                      const Gap(30),
                      Text(
                        "Aucune Note Pour le Moment",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Gap(20),
                      const Text(
                        "Vous n'avez pas encore évalué de séjour.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, item, index) => RatingHistoryCard(
                  rating: item,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
