import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/for_you/logic/scope_feed_cubit.dart';
import 'package:immoplus/app/features/for_you/logic/scope_feed_state.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_section_view.dart';
import 'package:immoplus/app/widgets/filters/feed_search_header_card.dart';
import 'package:immoplus/app/widgets/notification_bell.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';

/// Page d'accueil dédiée pour les onglets "Trouver un logement", "Acheter un bien", "Séjour".
/// Intègre le formulaire de recherche flottant dynamique (issu de `GET /me/search/filters`)
/// et le flux vertical de sections (issu de `GET /me/rent`, `/me/buy` ou `/me/stay`).
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

                        // ── Carte de recherche d'en-tête ──
                        SliverToBoxAdapter(
                          child: FeedSearchHeaderCard(
                            scope: widget.scope,
                            destinationName: state.selectedAddress?.description,
                            onLocationSelected: _cubit.setAddress,
                            filters: state.filtersData?.filters ?? [],
                            selectedFilters: state.selectedFilters,
                            onFilterChanged: _cubit.setFilter,
                            onSearch: () {
                              // NB: Au clic sur rechercher ne fait aucune action pour l'instant
                            },
                          ),
                        ),

                        const SliverGap(8),

                        // ── Contenu du flux de sections (Vertical) ──
                        if (state.status == ScopeFeedStatus.loading &&
                            state.sections.isEmpty)
                          SliverToBoxAdapter(
                            child: _FeedLoadingShimmer(),
                          )
                        else if (state.status == ScopeFeedStatus.error &&
                            state.sections.isEmpty)
                          SliverToBoxAdapter(
                            child: _FeedErrorState(
                              message: state.errorMessage,
                              onRetry: _cubit.fetch,
                            ),
                          )
                        else if (state.sections.isEmpty)
                          SliverToBoxAdapter(
                            child: _FeedEmptyState(scope: widget.scope),
                          )
                        else
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= state.sections.length) {
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

                                // Détection pagination infinie
                                if (index == state.sections.length - 2 &&
                                    state.hasMore &&
                                    !state.isLoadingMore) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) _cubit.loadMore();
                                  });
                                }

                                final section = state.sections[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: kHomeSectionSpacing,
                                  ),
                                  child: ForYouSectionView.vertical(
                                    section: section,
                                  ),
                                );
                              },
                              childCount: state.sections.length +
                                  (state.hasMore ? 1 : 0),
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
