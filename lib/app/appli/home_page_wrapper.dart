import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/appli/utils/navigation_handler.dart';
import 'package:immoplus/app/features/prop_feed/feed_controller.dart';
import 'package:immoplus/app/features/prop_feed/video_feed_warmup_service.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';

import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/ai_assistant/widgets/ai_floating_button.dart';

class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<HomePageWrapper> createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  final navigationHandler = getIt<NavigationHandler>();
  final sessionManager = getIt<SessionManager>();
  Timer? _videoFeedWarmupTimer;
  // Scroll-to-right désactivé : la pilule reste centrée.
  // Timer? _scrollIdleTimer;
  //
  // bool _handleScrollNotification(ScrollNotification notification) {
  //   if (notification is ScrollUpdateNotification ||
  //       notification is ScrollStartNotification) {
  //     if (!aiFabCollapsedNotifier.value) {
  //       aiFabCollapsedNotifier.value = true;
  //     }
  //     _scrollIdleTimer?.cancel();
  //     _scrollIdleTimer = Timer(const Duration(milliseconds: 400), () {
  //       if (mounted) aiFabCollapsedNotifier.value = false;
  //     });
  //   }
  //   return false;
  // }

  int _indexForState(PageState state) {
    switch (state) {
      case PageState.home:
        return 0;
      case PageState.forMe:
        return 1;
      case PageState.vivre:
        return 2;
      case PageState.explore:
        return 3;
      case PageState.account:
        return 4;
      case PageState.history:
      case PageState.map:
        return 0;
    }
  }

  static const int _vivreTabIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoFeedWarmupTimer?.cancel();
      _videoFeedWarmupTimer = Timer(const Duration(milliseconds: 2500), () {
        if (!mounted) return;

        // Si l'utilisateur est déjà sur "Vivre" ou si le feed a déjà été créé,
        // aucun intérêt de préchauffer.
        final current = context.read<NavigationCubit>().state;
        if (current == PageState.vivre) return;
        if (Get.isRegistered<VideoFeedController>()) return;

        final warmup = Get.isRegistered<VideoFeedWarmupService>()
            ? Get.find<VideoFeedWarmupService>()
            : Get.put(VideoFeedWarmupService(), permanent: true);

        // Best-effort (pas d'await) : ne doit jamais impacter l'UI.
        unawaited(warmup.warmup());
      });
    });
  }

  void _onItemTapped({required int index, required PageState pageState}) {
    if (_indexForState(pageState) == index) {
      return;
    }

    // Si on clique sur "Mes choix" (index 1), on vérifie si l'utilisateur est connecté
    if (index == 1 && sessionManager.currentUser == null) {
      context.pushNamed(
        AuthenticationPage.name,
        extra: (
          callback: () {
            // Une fois connecté, on switch sur la page "Mes choix"
            navigationHandler.switchPage(id: index, context: context);
          },
          popUntilRouteName:
              null, // On ne pop pas, on veut juste revenir/continuer
        ) as AuthRedirectData,
      );
      return;
    }

    if (Get.isRegistered<VideoFeedController>()) {
      final feedCtrl = Get.find<VideoFeedController>();
      if (pageState == PageState.vivre && index != _vivreTabIndex) {
        feedCtrl.onFeedHidden();
        feedCtrl
            .saveSessionTimestamp(); // timestamp pour la logique 30 min au retour
      } else if (index == _vivreTabIndex) {
        feedCtrl.onFeedVisible();
      }
    }
    navigationHandler.switchPage(id: index, context: context);
  }

  @override
  void dispose() {
    _videoFeedWarmupTimer?.cancel();
    _videoFeedWarmupTimer = null;
    // _scrollIdleTimer?.cancel();
    // _scrollIdleTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, PageState>(
      builder: (context, state) {
        return ValueListenableBuilder<bool>(
          valueListenable: Constantes.hideBottomNavNotifier,
          builder: (context, hideBottomNav, _) {
            return Scaffold(
              body: widget.child,
              floatingActionButton:
                  state == PageState.home ? const AiFloatingButton() : null,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              bottomNavigationBar: hideBottomNav
                  ? null
                  : Container(
                      decoration: BoxDecoration(
                        // borderRadius: const BorderRadius.only(
                        //   topLeft: Radius.circular(20),
                        //   topRight: Radius.circular(20),
                        // ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        // borderRadius: const BorderRadius.only(
                        //   topLeft: Radius.circular(20),
                        //   topRight: Radius.circular(20),
                        // ),
                        child: SizedBox(
                          height: Platform.isAndroid ? 105 : null,
                          child: BottomNavigationBar(
                            type: BottomNavigationBarType.fixed,
                            backgroundColor: state == PageState.vivre
                                ? Colors.black
                                : Colors.white,
                            currentIndex: _indexForState(state),
                            onTap: (value) =>
                                _onItemTapped(index: value, pageState: state),
                            selectedFontSize: 12,
                            unselectedFontSize: 12,
                            showSelectedLabels: true,
                            showUnselectedLabels: true,
                            selectedItemColor: AppColors.primary,
                            unselectedItemColor: state == PageState.vivre
                                ? Colors.white
                                : Colors.grey,
                            items: [
                              _buildNavItem(
                                icon: Iconsax.home,
                                label: "Accueil",
                                isActive: state == PageState.home,
                                immoMode: state == PageState.vivre,
                              ),
                              _buildNavItem(
                                icon: Iconsax.heart,
                                label: "Mes choix",
                                isActive: state == PageState.forMe,
                                immoMode: state == PageState.vivre,
                                svgAsset: 'assets/svgs/icons/choice.svg',
                              ),
                              _buildNavItemVivre(
                                  isActive: state == PageState.vivre),
                              _buildNavItem(
                                icon: Iconsax.location,
                                label: "Carte",
                                isActive: state == PageState.explore,
                                immoMode: state == PageState.vivre,
                              ),
                              _buildNavItem(
                                icon: Iconsax.user,
                                label: "Compte",
                                isActive: state == PageState.account,
                                immoMode: state == PageState.vivre,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool immoMode,
    String? svgAsset,
  }) {
    final inactiveColor = immoMode ? Colors.white : Colors.grey.shade600;

    Widget buildIcon({required bool active}) {
      if (svgAsset != null) {
        return SvgPicture.asset(
          svgAsset,
          width: active ? 24 : 25,
          height: active ? 24 : 25,
          colorFilter: ColorFilter.mode(
            active ? AppColors.primary : inactiveColor,
            BlendMode.srcIn,
          ),
        );
      }
      return Icon(
        icon,
        color: active ? AppColors.primary : inactiveColor,
        size: active ? 24 : 25,
      );
    }

    return BottomNavigationBarItem(
      icon: isActive
          ? Container(
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: immoMode
                  ? BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: buildIcon(active: true),
            )
          : SizedBox(
              height: 40,
              child: buildIcon(active: false),
            ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildNavItemVivre({required bool isActive}) {
    return BottomNavigationBarItem(
      icon: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        // decoration: BoxDecoration(

        //   borderRadius: BorderRadius.circular(12),
        // ),
        child: Image.asset(
          'assets/img/icon_video_2.png',
          width: 26,
          height: 26,
        ),
      ),
      label: 'Reels',
    );
  }
// BottomNavigationBarItem _buildNavItemVivre({required bool isActive}) {
//   return BottomNavigationBarItem(
//     icon: Container(
//       height: 40,
//       padding: const EdgeInsets.all(8),
//       child: isActive
//           ? Icon(
//               Iconsax.play5,
//               color: AppColors.primary,
//               size: 28,
//             )
//           : Icon(
//               Iconsax.play,
//               size: 28,
//             ),
//     ),
//     label: 'Reels',
//   );
// }
}
