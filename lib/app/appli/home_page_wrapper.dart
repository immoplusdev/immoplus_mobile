import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/appli/utils/navigation_handler.dart';
import 'package:immoplus/app/features/prop_feed/feed_controller.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';

import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({super.key, required this.child});
  final Widget child;

  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  final navigationHandler = getIt<NavigationHandler>();
  final sessionManager = getIt<SessionManager>();

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

  void _onItemTapped({required int index, required PageState pageState}) {
    if (_indexForState(pageState) == index) {
      return;
    }
    if (Get.isRegistered<VideoFeedController>()) {
      final feedCtrl = Get.find<VideoFeedController>();
      if (pageState == PageState.vivre && index != _vivreTabIndex) {
        feedCtrl.onFeedHidden();
        feedCtrl.saveSessionTimestamp(); // timestamp pour la logique 30 min au retour
      } else if (index == _vivreTabIndex) {
        feedCtrl.onFeedVisible();
      }
    }
    navigationHandler.switchPage(id: index, context: context);
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
                  backgroundColor:
                      state == PageState.vivre ? Colors.black : Colors.white,
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
                      label: "Favoris",
                      isActive: state == PageState.forMe,
                      immoMode: state == PageState.vivre,
                    ),
                    _buildNavItemVivre(isActive: state == PageState.vivre),
                    _buildNavItem(
                      icon: Iconsax.location,
                      label: "Explorer",
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
  }) {
    final inactiveColor = immoMode ? Colors.white : Colors.grey.shade600;
    return BottomNavigationBarItem(
      icon: isActive
          ? Container(
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: immoMode
                  ? BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            )
          : SizedBox(
              height: 40,
              child: Icon(
                icon,
                color: inactiveColor,
                size: 25,
              ),
            ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildNavItemVivre({required bool isActive}) {
  return BottomNavigationBarItem(
    icon: Container(
      height: 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.primary.withOpacity(0.15), // 👈 couleur inactive
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isActive ? Iconsax.play5 : Iconsax.play5,
        color: AppColors.primary ,
        size: 25,
      ),
    ),
    label: 'Video',
  );
}
}
