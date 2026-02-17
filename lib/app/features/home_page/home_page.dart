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
  late TabController _tabController;
  final sessionManager = getIt<SessionManager>();
  final _remoteConfig = getIt<RemoteConfigService>();

  @override
  void initState() {
    context.read<NavigationCubit>().switchPage(PageState.home);
    () {
      HistoryPageState.refrechAll();
    }();
    _tabController = TabController(length: 4, vsync: this);
    final notificationService = getIt<NotificationService>();
    notificationService.setupNotificationListener();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await UpdateService()
          .checkForUpdate(context, forceUpdate: _remoteConfig.forceUpgradeApp);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    FilterHandler.search = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        _tabController.animateTo(state.indexPage);
        return EnvironmentsBadge(
          child: Scaffold(
            backgroundColor: AppColors.whiteBackground,
            body: DefaultTabController(
              length: 4,
              child: RefreshIndicator(
                onRefresh: () async {
                  HomePageState.getPageListController(state.indexPage)
                      .refresh();
                },
                child: CustomScrollView(
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
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    spacing: 8,
                                    children:
                                        FilterHandler.getActiveFiltersChips(
                                      onRefresh: () async {
                                        HomePageState.getPageListController(
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
            ),
          ),
        );
      },
    );
  }
}
