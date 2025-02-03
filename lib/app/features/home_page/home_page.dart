library homePage;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/screens/history_page_state.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import 'components/home_search_appbar.dart';

part 'widgets/about_secton.dart';
part 'widgets/custom_app_bar.dart';
part 'widgets/header_section.dart';
part 'widgets/home_section_loading.dart';

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

  @override
  void initState() {
    context.read<NavigationCubit>().switchPage(PageState.home);
    () {
      HistoryPageState.refrechAll();
    }();
    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    HistoryPageState.search = null;
  }

  // Create a ScrollController to listen for scroll events
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //print('ACCOUNT ${UserModel().emailVerified}');
    //inspect(Constantes.configApp);
    //Constantes.buildNotifier.value = !Constantes.buildNotifier.value;
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        _tabController.animateTo(state.indexPage);
        return Scaffold(
          backgroundColor: AppColors.whiteBackground,
          body: DefaultTabController(
            length: 4,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                HomeSearchAppbar(
                  currentIndex: state.indexPage,
                  controller: _tabController,
                ),
                CupertinoSliverRefreshControl(
                  //      backgroundColor: Colors.white,
                  // color: Theme.of(context).colorScheme.primary,
                  onRefresh: () async {
                    HomePageState.getPageListController(state.indexPage)
                        .refresh();
                    // _pagingController.refresh();
                  },
                ),
                const SliverGap(10),
                HomePageState.getPageListFromIndex(state.indexPage),
              ],
            ),
          ),

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     if (SessionManager().currentUser != null) {
          //       print(SessionManager().currentUser!.userId);
          //       OneSignal.login(SessionManager().currentUser!.userId ?? '');
          //     }
          //     // InAppNotifications.show(
          //     //     title: 'Welcome to InAppNotifications',
          //     //     leading: Icon(
          //     //       Icons.fact_check,
          //     //       color: Colors.green,
          //     //       size: 50,
          //     //     ),
          //     //     ending: Icon(
          //     //       Icons.arrow_right_alt,
          //     //       color: Colors.red,
          //     //     ),
          //     //     description:
          //     //         'This is a very simple notification with leading and ending widget.',
          //     //     onTap: () {
          //     //       // Do whatever you need!
          //     //     });
          //   },
          // ),

          // floatingActionButton: _displayPanier
          //     ? PannierButton(
          //         onSearchEnd: () {
          //           Future.delayed(Duration.zero, () {
          //             setState(() {
          //               _displayPanier = false;
          //             });
          //           });
          //         },
          //       )
          //     : null,
        );
      },
    );
  }

  //final bool _displayPanier = true;
}
