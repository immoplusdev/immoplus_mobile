library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/core/services/remote_config_service.dart';
import 'package:immoplus/app/core/services/version_update_service.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/screens/history_page_state.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/config_env.dart';
import 'package:immoplus/app/logic/banners/banners_cubit.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'components/home_search_appbar.dart';

// part 'widgets/about_secton.dart';
// part 'widgets/custom_app_bar.dart';
// part 'widgets/header_section.dart';
// part 'widgets/home_section_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String name = "home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const double _scrollToTopThreshold = 420;
  late TabController _tabController;
  late final ScrollController _scrollController;
  final sessionManager = getIt<SessionManager>();
  final _remoteConfig = getIt<RemoteConfigService>();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    context.read<NavigationCubit>().switchPage(PageState.home);
    () {
      HistoryPageState.refrechAll();
    }();
    _tabController = TabController(length: 5, vsync: this);
    _scrollController = ScrollController()..addListener(_handleScrollChanged);
    final notificationService = getIt<NotificationService>();
    notificationService.setupNotificationListener();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await UpdateService()
          .checkForUpdate(context, forceUpdate: _remoteConfig.forceUpgradeApp);
      if (mounted) {
        await context.read<HomePageCubit>().syncUserPreferences();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScrollChanged)
      ..dispose();
    _tabController.dispose();
    super.dispose();
    FilterHandler.search = null;
    FilterHandler.lat = null;
    FilterHandler.long = null;
    FilterHandler.locationName = null;
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
    return BlocProvider(
      create: (context) => getIt<BannersCubit>()
        ..fetchBanners()
        ..startPolling(),
      child: BlocConsumer<HomePageCubit, HomePageState>(
        listenWhen: (previous, current) =>
            previous.indexPage != current.indexPage,
        listener: (context, state) {
          if (_tabController.index != state.indexPage && mounted) {
            _tabController.animateTo(state.indexPage);
          }
        },
        builder: (context, state) {
          return EnvironmentsBadge(
            child: Scaffold(
              backgroundColor: AppColors.white,
              body: DefaultTabController(
                length: 5,
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await context.read<BannersCubit>().fetchBanners();
                        if (state.indexPage == HomeTab.residence.value) {
                          HomePageState.refreshResidences();
                        } else {
                          HomePageState.getPageListController(state.indexPage)
                              .refresh();
                        }
                      },
                      child: CustomScrollView(
                        controller: _scrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        slivers: [
                          HomeSearchAppbar(
                            currentIndex: state.indexPage,
                            controller: _tabController,
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: FilterHandler.notifier,
                            builder: (context, _, child) {
                              return FilterHandler.hasActiveFilters
                                  ? SliverToBoxAdapter(
                                      child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Row(
                                          spacing: 8,
                                          children: FilterHandler
                                              .getActiveFiltersChips(
                                            onRefresh: () async {
                                              HomePageState
                                                      .getPageListController(
                                                          state.indexPage)
                                                  .refresh();
                                            },
                                          ),
                                        ),
                                      ),
                                    ))
                                  : const SliverToBoxAdapter();
                            },
                          ),
                          const SliverGap(10),
                          HomePageState.getPageListFromIndex(state.indexPage),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 15,
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
                              color: Colors.transparent,
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
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    color: Colors.white,
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
        },
      ),
    );
  }
}
