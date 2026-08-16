import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/rating/residence_review_model.dart';
import 'package:immoplus/app/data/repositories/rating_repository.dart';
import 'package:immoplus/app/features/residence_detail/components/residence_review_card.dart';

/// Section "Avis" de la page détail résidence.
/// GET /ratings/residence/{residenceId} — masquée entièrement si l'appel
/// échoue ou si la résidence n'a aucun avis (pas de skeleton qui reste
/// affiché, pas de section vide).
class RatingLogmentSection extends StatefulWidget {
  const RatingLogmentSection({super.key, required this.residenceId});

  final String residenceId;

  @override
  State<RatingLogmentSection> createState() => _RatingLogmentSectionState();
}

class _RatingLogmentSectionState extends State<RatingLogmentSection> {
  final RatingRepository _repository = getIt<RatingRepository>();

  bool _isLoading = true;
  List<ResidenceReviewModel> _reviews = const [];
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await _repository.getResidenceReviews(
        widget.residenceId,
        page: 1,
        perPage: 10,
      );
      if (!mounted) return;
      setState(() {
        _reviews = response.data;
        _totalCount = response.summary?.totalReviews ?? response.totalCount;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const _ReviewsSkeleton();
    if (_reviews.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: appPadding,
              right: appPadding,
              bottom: 4,
            ),
            child: Text(
              'Avis ($_totalCount)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                height: 1.2,
                color: Color(0xFF222222),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 210,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              scrollDirection: Axis.horizontal,
              itemCount: _reviews.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: VerticalDivider(color: Colors.grey.shade200, width: 1),
              ),
              itemBuilder: (context, index) {
                final screenWidth = MediaQuery.sizeOf(context).width;
                return ResidenceReviewCard(
                  review: _reviews[index],
                  width: screenWidth - appPadding * 2 - 48,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding),
            child: Center(
              child: GestureDetector(
                onTap: () => _showAllReviews(context),
                child: Text(
                  'Afficher les $_totalCount commentaires',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff2744de),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllReviews(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _AllReviewsSheet(
        residenceId: widget.residenceId,
        totalCount: _totalCount,
      ),
    );
  }
}

class _ReviewsSkeleton extends StatelessWidget {
  const _ReviewsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appPadding),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 100, height: 16, color: Colors.white),
              const SizedBox(height: 16),
              Row(
                children: [
                  const CircleAvatar(radius: 24, backgroundColor: Colors.white),
                  const SizedBox(width: 12),
                  Container(width: 120, height: 16, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Container(width: double.infinity, height: 12, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: double.infinity, height: 12, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: 180, height: 12, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feuille "Tous les avis" — liste verticale paginée.
class _AllReviewsSheet extends StatefulWidget {
  const _AllReviewsSheet({required this.residenceId, required this.totalCount});

  final String residenceId;
  final int totalCount;

  @override
  State<_AllReviewsSheet> createState() => _AllReviewsSheetState();
}

class _AllReviewsSheetState extends State<_AllReviewsSheet> {
  final RatingRepository _repository = getIt<RatingRepository>();
  final PagingController<int, ResidenceReviewModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await _repository.getResidenceReviews(
        widget.residenceId,
        page: pageKey,
        perPage: 10,
      );
      if (response.hasNext) {
        _pagingController.appendPage(response.data, pageKey + 1);
      } else {
        _pagingController.appendLastPage(response.data);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding),
            child: Text(
              'Avis (${widget.totalCount})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF222222),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PagedListView<int, ResidenceReviewModel>(
              scrollController: scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: appPadding,
                vertical: 4,
              ),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<ResidenceReviewModel>(
                itemBuilder: (context, review, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ResidenceReviewCard(review: review),
                ),
                firstPageProgressIndicatorBuilder: (context) => const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                newPageProgressIndicatorBuilder: (context) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
