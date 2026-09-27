import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';
import 'package:adaptive_liquid_bottom_nav_bar/adaptive_liquid_bottom_nav_bar.dart';
import 'package:immoplus/app/appli/utils/navigation_handler.dart';
import 'package:immoplus/app/features/prop_feed/feed_controller.dart';
import 'package:immoplus/app/features/prop_feed/video_feed_warmup_service.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';

import 'package:immoplus/app/appli/widgets/nav_badge.dart';
import 'package:immoplus/app/core/services/messaging_socket_service.dart';
import 'package:immoplus/app/data/repositories/alert_repository.dart';
import 'package:immoplus/app/data/repositories/messaging_repository.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
// import 'package:immoplus/app/features/ai_assistant/widgets/ai_floating_button.dart';

class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<HomePageWrapper> createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper>
    with WidgetsBindingObserver {
  final navigationHandler = getIt<NavigationHandler>();
  final sessionManager = getIt<SessionManager>();
  final _alertRepository = getIt<AlertRepository>();
  final _messagingRepository = getIt<MessagingRepository>();
  final _messagingSocketService = getIt<MessagingSocketService>();
  StreamSubscription? _messagingNotificationSub;
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
      case PageState.messages:
        return 3;
      case PageState.account:
        return 4;
      case PageState.explore:
      case PageState.history:
      case PageState.map:
        return 0;
    }
  }

  static const int _vivreTabIndex = 2;

  void _fetchImatchBadge() {
    if (sessionManager.currentUser == null) return;
    _alertRepository.getImatchBadgeCount().then((count) {
      if (mounted) Constantes.imatchBadgeCount.value = count;
    });
  }

  void _fetchUnreadMessagesCount() {
    if (sessionManager.currentUser == null) return;
    _messagingRepository.getTotalUnreadCount().then((count) {
      if (mounted) Constantes.unreadMessagesCount.value = count;
    });
  }

  /// Incrément local immédiat sur `notification_new` (spec messagerie §1),
  /// pour que le badge bouge partout dans l'app, pas seulement pendant que
  /// l'onglet Messages (et son `InboxCubit`) est ouvert. Le socket est déjà
  /// connecté dès la session ouverte (voir `session_manager.dart`), donc ce
  /// listener suffit sans reconnecter quoi que ce soit ici.
  void _listenForUnreadMessages() {
    _messagingNotificationSub?.cancel();
    _messagingNotificationSub =
        _messagingSocketService.onNotificationNew.listen((_) {
      Constantes.unreadMessagesCount.value += 1;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchImatchBadge();
      _fetchUnreadMessagesCount();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AdaptiveLiquidBottomNavigationBar.precacheIOSVersion();
    _fetchImatchBadge();
    _fetchUnreadMessagesCount();
    _listenForUnreadMessages();
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

    // Si on clique sur "Messages" (index 3) sans être connecté, direction
    // inscription/connexion plutôt que l'inbox (qui échouerait en 401).
    if (index == 3 && sessionManager.currentUser == null) {
      context.pushNamed(
        AuthenticationPage.name,
        extra: (
          callback: () {
            _fetchUnreadMessagesCount();
            navigationHandler.switchPage(id: index, context: context);
          },
          popUntilRouteName: null,
        ) as AuthRedirectData,
      );
      return;
    }

    // Si on clique sur "Imatch" (index 1), on vérifie si l'utilisateur est connecté
    if (index == 1 && sessionManager.currentUser == null) {
      context.pushNamed(
        AuthenticationPage.name,
        extra: (
          callback: () {
            _fetchImatchBadge();
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
    WidgetsBinding.instance.removeObserver(this);
    _messagingNotificationSub?.cancel();
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
              extendBody: true,
              body: widget.child,
              floatingActionButton:
                  // state == PageState.home ? const AiFloatingButton() : null,
                  null,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              bottomNavigationBar: hideBottomNav
                  ? null
                  : ListenableBuilder(
                      listenable: Listenable.merge([
                        Constantes.imatchBadgeCount,
                        Constantes.unreadMessagesCount,
                      ]),
                      builder: (context, _) {
                        final msgBadge = Utils.formatBadgeCount(
                            Constantes.unreadMessagesCount.value);
                        final imatchBadge = Utils.formatBadgeCount(
                            Constantes.imatchBadgeCount.value);

                        return AdaptiveLiquidBottomNavigationBar(
                          selectedIndex: _indexForState(state),
                          onDestinationSelected: (index) =>
                              _onItemTapped(index: index, pageState: state),
                          tint: AppColors.primary,
                          items: [
                            const AdaptiveBottomNavItem(
                              label: 'Accueil',
                              iosIconName: 'immo_home',
                              iosIconNameSelected: 'immo_home_fill',
                            ),
                            AdaptiveBottomNavItem(
                              label: 'Imatch',
                              iosIconName: 'immo_heart',
                              iosIconNameSelected: 'immo_heart_fill',
                              badgeValue: imatchBadge,
                            ),
                            const AdaptiveBottomNavItem(
                              label: 'Reels',
                              iosIconName: 'immo_reels',
                              iosIconNameSelected: 'immo_reels_fill',
                            ),
                            AdaptiveBottomNavItem(
                              label: 'Messages',
                              iosIconName: 'immo_message',
                              iosIconNameSelected: 'immo_message_fill',
                              badgeValue: msgBadge,
                            ),
                            const AdaptiveBottomNavItem(
                              label: 'Compte',
                              iosIconName: 'immo_user',
                              iosIconNameSelected: 'immo_user_fill',
                            ),
                          ],
                          fallback: _buildFallbackBar(context, state),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }

  /// Barre native "maison" (badges, icône Reels custom) — utilisée par
  /// `AdaptiveLiquidBottomNavigationBar.fallback` sur Android et iOS < 26, là où le rendu
  /// glass natif n'est pas disponible.
  Widget _buildFallbackBar(BuildContext context, PageState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ClipRRect(
        child: SizedBox(
          height: Platform.isAndroid
              ? 80 + MediaQuery.of(context).padding.bottom
              : null,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor:
                state == PageState.vivre ? Colors.black : Colors.white,
            currentIndex: _indexForState(state),
            onTap: (value) => _onItemTapped(index: value, pageState: state),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.primary,
            unselectedItemColor:
                state == PageState.vivre ? Colors.white : Colors.grey,
            items: [
              _buildNavItem(
                icon: Iconsax.home,
                label: "Accueil",
                isActive: state == PageState.home,
                immoMode: state == PageState.vivre,
              ),
              _buildNavItem(
                icon: Iconsax.heart,
                label: "Imatch",
                isActive: state == PageState.forMe,
                immoMode: state == PageState.vivre,
                svgAsset: 'assets/svgs/icons/immomacth.svg',
                badgeWidget: NavBadge(notifier: Constantes.imatchBadgeCount),
              ),
              _buildNavItemVivre(isActive: state == PageState.vivre),
              _buildNavItem(
                icon: Iconsax.messages_3,
                label: "Messages",
                isActive: state == PageState.messages,
                immoMode: state == PageState.vivre,
                badgeWidget: NavBadge(notifier: Constantes.unreadMessagesCount),
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
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool immoMode,
    String? svgAsset,
    Widget? badgeWidget,
  }) {
    final inactiveColor = immoMode ? Colors.white : Colors.grey.shade600;

    Widget buildIcon({required bool active}) {
      Widget base;
      if (svgAsset != null) {
        base = SvgPicture.asset(
          svgAsset,
          width: active ? 24 : 25,
          height: active ? 24 : 25,
          colorFilter: ColorFilter.mode(
            active ? AppColors.primary : inactiveColor,
            BlendMode.srcIn,
          ),
        );
      } else {
        base = Icon(
          icon,
          color: active ? AppColors.primary : inactiveColor,
          size: active ? 24 : 25,
        );
      }

      if (badgeWidget != null) {
        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              base,
              Positioned(top: -4, right: -6, child: badgeWidget),
            ],
          ),
        );
      }
      return base;
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
        child: Image.asset(
          'assets/img/icon_video_2.png',
          width: 26,
          height: 26,
        ),
      ),
      label: 'Reels',
    );
  }
}
