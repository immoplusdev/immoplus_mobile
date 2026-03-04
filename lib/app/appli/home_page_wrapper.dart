import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/appli/utils/navigation_handler.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({super.key, required this.child});
  final Widget child;

  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  int _selectedIndex = 0;
  final navigationHandler = getIt<NavigationHandler>();
  final sessionManager = getIt<SessionManager>();

  void _onItemTapped({required int index, required PageState pageState}) {
    // Compte (index 3) requiert une authentification
    if (index == 3) {
      if (sessionManager.currentUser == null) {
        context.pushNamed(AuthenticationPage.name);
        return;
      }
    }
    setState(() => _selectedIndex = index);
    navigationHandler.switchPage(id: index, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, PageState>(
      builder: (context, state) {
        return Scaffold(
          body: widget.child,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: SizedBox(
                height: Platform.isAndroid ? 105 : null,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  currentIndex: _selectedIndex,
                  onTap: (value) =>
                      _onItemTapped(index: value, pageState: state),
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: Colors.grey,
                  items: [
                    _buildNavItem(
                      icon: Iconsax.home,
                      activeIcon: Iconsax.home5,
                      label: 'Accueil',
                      isActive: state == PageState.home,
                    ),
                    _buildNavItem(
                      icon: Iconsax.heart,
                      activeIcon: Iconsax.heart5,
                      label: 'Favoris',
                      isActive: state == PageState.forMe,
                    ),
                    _buildNavItem(
                      icon: Iconsax.location,
                      activeIcon: Iconsax.location5,
                      label: 'Explorer',
                      isActive: state == PageState.explore,
                    ),
                    _buildNavItem(
                      icon: Iconsax.profile_circle,
                      activeIcon: Iconsax.profile_circle5,
                      label: 'Compte',
                      isActive: state == PageState.acount,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: isActive
          ? Container(
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                activeIcon,
                color: AppColors.primary,
                size: 24,
              ),
            )
          : SizedBox(
              height: 40,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.grey.shade600,
                  size: 24,
                ),
              ),
            ),
      label: label,
    );
  }
}
