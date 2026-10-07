import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/data/models/remote/search_filters/scope_search_response.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/for_you/logic/scope_feed_cubit.dart';
import 'package:immoplus/app/features/for_you/logic/scope_feed_state.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_vertical_card.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/widgets/ads/resolved_ad_card.dart';
import 'package:immoplus/app/widgets/filters/feed_search_header_card.dart';
import 'package:immoplus/app/widgets/notification_bell.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/utils/utils.dart';

/// Page d'accueil dédiée pour les onglets « Trouver un logement »,
/// « Acheter un bien », « Séjour ».
///
/// Implémente le cycle de `ONG.MD` :
///   - Chargement initial → liste de cartes groupées par section
///   - Filtres appliqués sur le même endpoint que la liste
///   - Bouton « Chercher » → fusionne les params des filtres et relance la recherche
///   - Pagination par curseur lors du défilement
class ScopeFeedPage extends StatefulWidget {
  final HomeFeedScope scope;
  final String? title;

  const ScopeFeedPage({
    super.key,
    required this.scope,
    this.title,
  });

  String get displayTitle => title ?? scope.defaultTitle;

  static const String routePath = '/scope-feed';
  static const String routeName = 'scope_feed';

  @override
  State<ScopeFeedPage> createState() => _ScopeFeedPageState();
}

class _ScopeFeedPageState extends State<ScopeFeedPage> {
  static const double _scrollToTopThreshold = 420;
  late final ScrollController _scrollController;
  late final ScopeFeedCubit _cubit;
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScrollChanged);
    _cubit = getIt<ScopeFeedCubit>(param1: widget.scope)..fetch();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScrollChanged)
      ..dispose();
    _cubit.close();
    super.dispose();
  }

  void _handleScrollChanged() {
    if (!_scrollController.hasClients) return;
    final shouldShow = _scrollController.offset > _scrollToTopThreshold;
    if (shouldShow != _showScrollToTopButton && mounted) {
      setState(() => _showScrollToTopButton = shouldShow);
    }

    // ONG.MD §5 : charger la page suivante vers 70 % de la liste.
    final position = _scrollController.position;
    if (position.maxScrollExtent > 0 &&
        position.pixels >= position.maxScrollExtent * 0.7) {
      unawaited(_cubit.loadMore());
    }
  }

  Future<void> _scrollToTop() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final baseBottom = bottomInset + 10;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leadingWidth: 60,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Center(
              child: InkWell(
                onTap: () => Navigator.maybePop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            widget.displayTitle,
            style: AppTypography.font(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: NotificationBell(
                  backgroundColor: AppColors.white,
                  size: 40,
                  iconSize: 20,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              BlocBuilder<ScopeFeedCubit, ScopeFeedState>(
                builder: (context, state) {
                  final cheapestItems = state.items
                      .where((item) =>
                          !item.isAd &&
                          HomeFeedSectionType.cheapestKeys
                              .contains(item.sectionKey))
                      .toList(growable: false);
                  final regularItems = state.items
                      .where((item) =>
                          item.isAd ||
                          !HomeFeedSectionType.cheapestKeys
                              .contains(item.sectionKey))
                      .toList(growable: false);
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _cubit.fetch();
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        // Petit indicateur / poignée grise en haut de la feuille blanche (Figma)
                        SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 8),
                              width: 44,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1D5DB),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),

                        // ── Carte de recherche d'en-tête (ONG.MD §3) ──
                        SliverToBoxAdapter(
                          child: FeedSearchHeaderCard(
                            scope: widget.scope,
                            destinationName: state.selectedAddress?.description,
                            onLocationSelected: _cubit.setAddress,
                            filters: state.filtersData?.filters ?? const [],
                            selectedFilters: state.selectedFilters,
                            onFilterChanged: _cubit.setFilter,
                            // ONG.MD §4 : Au clic sur « Chercher », lancer la recherche
                            onSearch: () {
                              _cubit.search();
                            },
                          ),
                        ),

                        if (cheapestItems.isNotEmpty)
                          SliverToBoxAdapter(
                            child: _ScopeCheapestStackedSection(
                              items: cheapestItems,
                              title: cheapestItems.first.sectionTitle ??
                                  'Les moins chères',
                              onTap: (item) {
                                if (widget.scope.isStay) {
                                  context
                                      .push(ResidencePage.route(item.bienId));
                                } else {
                                  context.push(EstatePage.route(item.bienId));
                                }
                              },
                            ),
                          ),

                        const SliverGap(16),

                        // ── Contenu : liste plate de cartes (ONG.MD §2) ──
                        if (state.status == ScopeFeedStatus.loading &&
                            state.items.isEmpty)
                          SliverToBoxAdapter(
                            child: _FeedLoadingShimmer(),
                          )
                        else if (state.status == ScopeFeedStatus.error &&
                            state.items.isEmpty)
                          SliverToBoxAdapter(
                            child: _FeedErrorState(
                              message: state.errorMessage,
                              onRetry: _cubit.fetch,
                            ),
                          )
                        else if (state.items.isEmpty &&
                            state.status == ScopeFeedStatus.success)
                          SliverToBoxAdapter(
                            child: _FeedEmptyState(scope: widget.scope),
                          )
                        else
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= regularItems.length) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: state.isLoadingMore
                                          ? CircularProgressIndicator(
                                              color: AppColors.primary,
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  );
                                }

                                final item = regularItems[index];
                                if (item.isAd) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 12, 20, 12),
                                    child: ResolvedAdCard(campaign: item.ad!),
                                  );
                                }
                                final showSectionTitle = item.sectionTitle !=
                                        null &&
                                    item.sectionTitle!.isNotEmpty &&
                                    (index == 0 ||
                                        regularItems[index - 1].sectionTitle !=
                                            item.sectionTitle);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (showSectionTitle)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 16, 20, 2),
                                        child: Text(
                                          item.sectionTitle!,
                                          style: AppTypography.font(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      child: _buildItemCard(item),
                                    ),
                                  ],
                                );
                              },
                              childCount:
                                  regularItems.length + (state.hasMore ? 1 : 0),
                            ),
                          ),

                        SliverGap(baseBottom + 40),
                      ],
                    ),
                  );
                },
              ),

              // Bouton Scroll to top
              Positioned(
                right: 20,
                bottom: baseBottom,
                child: IgnorePointer(
                  ignoring: !_showScrollToTopButton,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: _showScrollToTopButton ? 1 : 0,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 180),
                      offset: _showScrollToTopButton
                          ? Offset.zero
                          : const Offset(0, 0.2),
                      child: Material(
                        color: AppColors.transparent,
                        child: InkWell(
                          onTap: _scrollToTop,
                          borderRadius: BorderRadius.circular(18),
                          child: Ink(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.1),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit une carte à partir d'un `ScopeSearchItem` (ONG.MD §6) :
  /// - `chips[0]` (1ère pastille, ex: "Cocody")
  /// - `chips[1]` (2è pastille, ex: "Appartement · 2 chambres")
  /// - `badge.label` et `badge.tier` (Pastille : "VIP", "Recommandé", "Nouveau")
  /// - Prix formaté en FCFA (`currency: "XOF"`)
  Widget _buildItemCard(ScopeSearchItem item) {
    // Déterminer si c'est un séjour/résidence (typeLocation == null ou "séjour")
    final isResidence = widget.scope.isStay;
    final isRent = item.aLouer || widget.scope.isRent;

    return ForYouVerticalCard(
      id: item.bienId,
      title: item.name,
      imageUrl: item.imageUrl,
      location: item.location,
      price: item.price,
      currency: item.currency ?? 'FCFA',
      isRent: isRent,
      isResidence: isResidence,
      description: item.description,
      chips: item.chips,
      badge: item.badge,
      onTap: () {
        if (isResidence) {
          context.push(ResidencePage.route(item.bienId));
        } else {
          context.push(EstatePage.route(item.bienId));
        }
      },
    );
  }
}

class _ScopeCheapestStackedSection extends StatefulWidget {
  const _ScopeCheapestStackedSection({
    required this.items,
    required this.title,
    required this.onTap,
  });

  final List<ScopeSearchItem> items;
  final String title;
  final ValueChanged<ScopeSearchItem> onTap;

  @override
  State<_ScopeCheapestStackedSection> createState() =>
      _ScopeCheapestStackedSectionState();
}

class _ScopeCheapestStackedSectionState
    extends State<_ScopeCheapestStackedSection> {
  static const _initialPage = 10000;
  late final PageController _pageController;
  final math.Random _random = math.Random();
  final Map<String, Offset> _stackOffsetsByCard = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _currentIndex = _initialPage % widget.items.length;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.items.length;
    if (count == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTypography.font(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const Gap(14),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardHeight = constraints.maxWidth * 220.9 / 355.6;
              return SizedBox(
                height: cardHeight + 20,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (count > 2)
                      _buildStackCard(
                          widget.items[(_currentIndex + 2) % count], 2),
                    if (count > 1)
                      _buildStackCard(
                          widget.items[(_currentIndex + 1) % count], 1),
                    PageView.builder(
                      controller: _pageController,
                      itemBuilder: (context, page) {
                        final item = widget.items[page % count];
                        return GestureDetector(
                          onTap: () => widget.onTap(item),
                          child: Center(child: _buildCard(item)),
                        );
                      },
                      onPageChanged: (page) {
                        setState(() => _currentIndex = page % count);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          if (count > 1) ...[
            const Gap(12),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  count > 8 ? 8 : count,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex % 8 == index ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex % 8 == index
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

  Widget _buildStackCard(ScopeSearchItem item, int depth) {
    final scale = 1 - depth * 0.05;
    final rotationDegrees = depth == 1 ? 3.61 : -2.05;
    final randomOffset = _stackOffsetFor(item, depth);
    return Transform.translate(
      offset: Offset(randomOffset.dx, depth * 10 + randomOffset.dy),
      child: Center(
        child: AnimatedRotation(
          turns: rotationDegrees / 360,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: 1 - depth * 0.18,
              child: _buildCard(item),
            ),
          ),
        ),
      ),
    );
  }

  Offset _stackOffsetFor(ScopeSearchItem item, int depth) {
    final cardId = item.bienId.isNotEmpty
        ? item.bienId
        : '${item.name}|${item.imageUrl ?? ''}';
    final horizontalRange = depth == 1 ? 4.0 : 7.0;
    final verticalRange = depth == 1 ? 1.5 : 3.0;
    return _stackOffsetsByCard.putIfAbsent(
      '$cardId:$depth',
      () => Offset(
        (_random.nextDouble() * 2 - 1) * horizontalRange,
        (_random.nextDouble() * 2 - 1) * verticalRange,
      ),
    );
  }

  Widget _buildCard(ScopeSearchItem item) {
    final imageUrl = item.imageUrl?.isNotEmpty == true
        ? Utils.getImagePath(id: item.imageUrl!)
        : null;
    return AspectRatio(
      aspectRatio: 355.6 / 220.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const ColoredBox(color: Color(0xFF2C3444)),
              )
            else
              const ColoredBox(color: Color(0xFF2C3444)),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF79E38),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.title,
                      style: AppTypography.font(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.font(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  if (item.description?.trim().isNotEmpty == true) ...[
                    const Gap(4),
                    Text(
                      item.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.font(
                        fontSize: 14,
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
    );
  }
}

class _FeedLoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: List.generate(
          2,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: double.infinity,
              height: 300,
              child: LoadProductCard(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _FeedErrorState({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: AppColors.immoTextSecondary,
            ),
            const Gap(14),
            Text(
              message ?? 'Impossible de charger le contenu',
              style: AppTypography.font(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(14),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Réessayer',
                style: AppTypography.font(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedEmptyState extends StatelessWidget {
  final HomeFeedScope scope;

  const _FeedEmptyState({required this.scope});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: AppColors.immoTextDisabled,
            ),
            const Gap(12),
            Text(
              'Aucun résultat disponible pour le moment',
              style: AppTypography.font(
                fontSize: 15,
                color: AppColors.immoTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
