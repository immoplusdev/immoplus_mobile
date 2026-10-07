import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/for_you/utils/see_more_fetcher.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_list_item.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:shimmer/shimmer.dart';

/// Section spéciale "Les moins chères" affichant les cartes sous forme de pile (stack)
/// interactive avec effet 3D / superposition et pagination in-place via `seeMoreEndpoint`.
class ForYouCheapestStackedSection extends StatefulWidget {
  final HomeFeedSection section;
  final EdgeInsetsGeometry padding;

  const ForYouCheapestStackedSection({
    super.key,
    required this.section,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  State<ForYouCheapestStackedSection> createState() =>
      _ForYouCheapestStackedSectionState();
}

class _ForYouCheapestStackedSectionState
    extends State<ForYouCheapestStackedSection>
    with SingleTickerProviderStateMixin {
  late List<HomeFeedListItem> _items;
  late int _currentPage;
  late int _limit;
  late bool _hasMore;
  bool _isLoadingMore = false;

  int _currentIndex = 0;
  Offset _dragOffset = Offset.zero;
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initData();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  @override
  void didUpdateWidget(covariant ForYouCheapestStackedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section.key != widget.section.key ||
        oldWidget.section.items.length != widget.section.items.length) {
      _initData();
    }
  }

  void _initData() {
    _items = widget.section.listItems.where((e) => !e.isAd).toList();
    _currentPage = widget.section.page;
    _limit = widget.section.limit;
    _hasMore = widget.section.hasSeeMore;
    _isLoadingMore = false;
    _currentIndex = 0;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  bool get _isResidence =>
      widget.section.type == HomeFeedSectionType.residenceList;

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

  void _onPanStart(DragStartDetails details) {
    if (_animController.isAnimating) return;
    setState(() {
      _dragOffset = Offset.zero;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_animController.isAnimating) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details, double cardWidth) {
    if (_animController.isAnimating) return;
    final velocityX = details.velocity.pixelsPerSecond.dx;
    final itemsCount = _items.length;

    if (itemsCount <= 1) {
      _resetPosition();
      return;
    }

    const swipeThreshold = 60.0;
    final shouldSwipeRight = _dragOffset.dx > swipeThreshold || velocityX > 350;
    final shouldSwipeLeft =
        _dragOffset.dx < -swipeThreshold || velocityX < -350;

    if (shouldSwipeRight || shouldSwipeLeft) {
      final isGoingPrevious = shouldSwipeRight;
      // En allant en avant : la carte du haut s'échappe vers la gauche (-cardWidth - 60)
      // En revenant en arrière : la carte précédente entre depuis la gauche jusqu'au centre (cardWidth)
      final targetDx = isGoingPrevious ? cardWidth : -cardWidth - 60.0;

      _slideAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset(targetDx, _dragOffset.dy),
      ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
      )..addListener(() {
          setState(() {
            _dragOffset = _slideAnimation.value;
          });
        });

      _animController.forward(from: 0).then((_) {
        setState(() {
          if (isGoingPrevious) {
            _currentIndex = (_currentIndex - 1 + itemsCount) % itemsCount;
          } else {
            _currentIndex = (_currentIndex + 1) % itemsCount;
          }
          _dragOffset = Offset.zero;
        });

        // Détection de pagination à l'approche de la fin de la pile en avançant
        if (!isGoingPrevious &&
            _currentIndex >= _items.length - 2 &&
            _hasMore &&
            !_isLoadingMore) {
          _loadNextPage();
        }
      });
    } else {
      _resetPosition();
    }
  }

  void _resetPosition() {
    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    )..addListener(() {
        setState(() {
          _dragOffset = _slideAnimation.value;
        });
      });
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final cardCount = _items.length;
    if (cardCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeSectionTitle(title: widget.section.title),
          const Gap(14),
          LayoutBuilder(
            builder: (context, outerConstraints) {
              final cardHeight = outerConstraints.maxWidth * 220.9 / 355.6;
              return SizedBox(
                height: cardHeight + 20,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth;
                    final isDraggingRight = _dragOffset.dx > 0;
                    final dragRatio = (cardWidth > 0
                            ? (_dragOffset.dx.abs() / cardWidth)
                            : 0.0)
                        .clamp(0.0, 1.0);

                    return GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: (details) => _onPanEnd(details, cardWidth),
                      onTap: () =>
                          _handleCardTap(_items[_currentIndex % cardCount]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          if (!isDraggingRight) ...[
                            // ── Navigation en avant (Swipe gauche) ──
                            // 3ème carte dans la pile
                            if (cardCount > 2)
                              _buildStackedCard(
                                item: _items[(_currentIndex + 2) % cardCount],
                                depth: 2,
                                dragRatio: dragRatio,
                              ),

                            // 2ème carte dans la pile
                            if (cardCount > 1)
                              _buildStackedCard(
                                item: _items[(_currentIndex + 1) % cardCount],
                                depth: 1,
                                dragRatio: dragRatio,
                              ),

                            // Carte principale active (qui glisse vers la gauche)
                            _buildTopCard(_items[_currentIndex % cardCount]),
                          ] else ...[
                            // ── Navigation en arrière (Swipe droit) ──
                            // La pile recule doucement en profondeur
                            if (cardCount > 2)
                              _buildStackedCard(
                                item: _items[(_currentIndex + 1) % cardCount],
                                depth: 2,
                                dragRatio: -dragRatio,
                              ),

                            if (cardCount > 1)
                              _buildStackedCard(
                                item: _items[_currentIndex % cardCount],
                                depth: 1,
                                dragRatio: -dragRatio,
                              ),

                            // Carte précédente qui entre fluidement depuis la gauche au-dessus de la pile
                            _buildIncomingPrevCard(
                              item: _items[
                                  (_currentIndex - 1 + cardCount) % cardCount],
                              cardWidth: cardWidth,
                              dragRatio: dragRatio,
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (cardCount > 1) ...[
            const Gap(12),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  math.min(cardCount, 8),
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: (_currentIndex % cardCount) == index ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: (_currentIndex % cardCount) == index
                          ? const Color(0xFFF79E38)
                          : AppColors.immoBorderDefault,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStackedCard({
    required HomeFeedListItem item,
    required int depth,
    required double dragRatio,
  }) {
    // Si dragRatio > 0 (swipe gauche) : la carte monte (targetDepth diminue)
    // Si dragRatio < 0 (swipe droite) : la carte recule (targetDepth augmente)
    final targetDepth = (depth - dragRatio).clamp(0.0, 2.5);

    final scale = (1.0 - (targetDepth * 0.05)).clamp(0.85, 1.0);
    final translateY = targetDepth * 10.0;
    final rotationAngle =
        depth == 1 ? (1.5 * math.pi / 180) : (-2.0 * math.pi / 180);

    return Transform(
      alignment: Alignment.center,
      transform: (Matrix4.translationValues(0.0, translateY, 0.0)
        ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0))
        ..rotateZ(rotationAngle * (1 - dragRatio.abs()))),
      child: Opacity(
        opacity: (1.0 - (targetDepth * 0.18)).clamp(0.0, 1.0),
        child: _CardContent(
          item: item,
          isResidence: _isResidence,
          sectionTitle: widget.section.title,
        ),
      ),
    );
  }

  Widget _buildTopCard(HomeFeedListItem item) {
    final rotationAngle = (_dragOffset.dx / 300) * (15 * math.pi / 180);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.translationValues(
        _dragOffset.dx,
        _dragOffset.dy * 0.3,
        0.0,
      )..rotateZ(rotationAngle),
      child: _CardContent(
        item: item,
        isResidence: _isResidence,
        sectionTitle: widget.section.title,
      ),
    );
  }

  Widget _buildIncomingPrevCard({
    required HomeFeedListItem item,
    required double cardWidth,
    required double dragRatio,
  }) {
    // La carte précédente commence à -cardWidth et se déplace vers 0.0 quand _dragOffset.dx atteint cardWidth
    final dx = _dragOffset.dx - cardWidth;
    final rotationAngle = (-12 * math.pi / 180) * (1.0 - dragRatio);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.translationValues(
        dx,
        _dragOffset.dy * 0.2,
        0.0,
      )..rotateZ(rotationAngle),
      child: _CardContent(
        item: item,
        isResidence: _isResidence,
        sectionTitle: widget.section.title,
      ),
    );
  }

  void _handleCardTap(HomeFeedListItem item) {
    if (_isResidence && item.asResidence != null) {
      context.push(ResidencePage.route(item.asResidence!.residenceId));
    } else if (!_isResidence && item.asBien != null) {
      context.push(EstatePage.route(item.asBien!.bienId));
    }
  }
}

class _CardContent extends StatelessWidget {
  final HomeFeedListItem item;
  final bool isResidence;
  final String sectionTitle;

  const _CardContent({
    required this.item,
    required this.isResidence,
    required this.sectionTitle,
  });

  String get _name {
    if (isResidence) return item.asResidence?.name ?? '';
    return item.asBien?.name ?? '';
  }

  String? get _description {
    if (isResidence) {
      final desc = item.asResidence?.description;
      if (desc != null && desc.trim().isNotEmpty) return desc;
      return item.asResidence?.location;
    }
    final desc = item.asBien?.description;
    if (desc != null && desc.trim().isNotEmpty) return desc;
    return item.asBien?.location;
  }

  String? get _imageUrl {
    if (isResidence) return item.asResidence?.imageUrl;
    return item.asBien?.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final formattedUrl = (_imageUrl != null && _imageUrl!.isNotEmpty)
        ? Utils.getImagePath(id: _imageUrl!)
        : '';

    return AspectRatio(
      aspectRatio: 355.6 / 220.9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.14),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Image de fond
              if (formattedUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: formattedUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 800,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.immoBorderStrong,
                    highlightColor: AppColors.immoBgSurfaceMuted,
                    period: const Duration(milliseconds: 500),
                    child: Container(color: AppColors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFF2C3444),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.images,
                        size: 40,
                        color: AppColors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  color: const Color(0xFF2C3444),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.images,
                      size: 40,
                      color: AppColors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),

              // 2. Dégradé sombre pour la lisibilité
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.78),
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                ),
              ),

              // 3. Contenu texte et badge orange
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge orange "Les moins chères"
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF79E38),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sectionTitle.isNotEmpty
                            ? sectionTitle
                            : 'Les moins cheres',
                        style: AppTypography.font(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const Gap(8),

                    // Titre
                    Text(
                      _name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.font(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),

                    // Description
                    if (_description != null &&
                        _description!.trim().isNotEmpty) ...[
                      const Gap(4),
                      Text(
                        _description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.font(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
