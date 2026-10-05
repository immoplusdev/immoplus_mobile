import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_list_item.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/for_you/utils/see_more_fetcher.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_cheapest_stacked_section.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_inline_ad_tile.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_vertical_card.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';

/// Rendu vertical des items d'une section `residence_list`/`bien_list`
/// avec pagination in-place automatique via `seeMoreEndpoint`.
class ForYouItemVerticalList extends StatefulWidget {
  final HomeFeedSection section;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;

  const ForYouItemVerticalList({
    super.key,
    required this.section,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.itemSpacing = 16.0,
  });

  @override
  State<ForYouItemVerticalList> createState() => _ForYouItemVerticalListState();
}

class _ForYouItemVerticalListState extends State<ForYouItemVerticalList> {
  late List<HomeFeedListItem> _items;
  late int _currentPage;
  late int _limit;
  late bool _hasMore;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant ForYouItemVerticalList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section.key != widget.section.key ||
        oldWidget.section.items.length != widget.section.items.length) {
      _initData();
    }
  }

  void _initData() {
    _items = List.from(widget.section.listItems);
    _currentPage = widget.section.page;
    _limit = widget.section.limit;
    _hasMore = widget.section.hasSeeMore;
    _isLoadingMore = false;
  }

  bool get _isResidence =>
      widget.section.type == HomeFeedSectionType.residenceList;

  bool get _isCheapest => widget.section.key == HomeFeedSectionType.cheapestKey;

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore || widget.section.seeMoreEndpoint == null) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;
    final result = await SeeMoreFetcher.fetch(
      seeMoreEndpoint: widget.section.seeMoreEndpoint!,
      page: nextPage,
      limit: _limit,
      isResidence: _isResidence,
    );

    if (!mounted) return;

    setState(() {
      _isLoadingMore = false;
      if (result.items.isNotEmpty) {
        _items.addAll(result.items);
        _currentPage = result.currentPage;
        _hasMore = result.hasNext;
      } else {
        _hasMore = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();

    if (_isCheapest) {
      return ForYouCheapestStackedSection(
        section: widget.section,
        padding: widget.padding,
      );
    }

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeSectionTitle(title: widget.section.title),
          const Gap(14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _items.length,
            separatorBuilder: (context, index) => Gap(widget.itemSpacing),
            itemBuilder: (context, index) {
              // Déclenchement automatique de la pagination à l'approche de la fin
              if (index >= _items.length - 2 && !_isLoadingMore && _hasMore) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _loadNextPage();
                });
              }

              final entry = _items[index];
              if (entry.isAd) {
                return ForYouInlineAdTile(campaign: entry.ad!);
              }

              if (!_isResidence) {
                final bien = entry.asBien!;
                return ForYouVerticalCard.fromBien(
                  bien: bien,
                  onTap: () => context.push(EstatePage.route(bien.bienId)),
                );
              }

              final residence = entry.asResidence!;
              return ForYouVerticalCard.fromResidence(
                residence: residence,
                onTap: () =>
                    context.push(ResidencePage.route(residence.residenceId)),
              );
            },
          ),
          if (_isLoadingMore) ...[
            const Gap(16),
            Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
