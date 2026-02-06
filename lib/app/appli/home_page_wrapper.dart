import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/appli/utils/navigation_handler.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/filter/filter_page.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/immo_icons.dart';

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
    if (index == 4) {
      if (sessionManager.currentUser == null) {
        context.pushNamed(AuthenticationPage.name);
        return;
      }
    }
    if (index == 2 && pageState == PageState.home) {
      _showFilterDialog();
    } else if (index != 2) {
      _selectedIndex = index;
      navigationHandler.switchPage(id: index, context: context);
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteBackground,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.88,
          child: const FilterPage()),
    );
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
                  color: Colors.black.withOpacity(0.1),
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
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                currentIndex: _selectedIndex,
                onTap: (value) => _onItemTapped(index: value, pageState: state),
                selectedFontSize: 12,
                unselectedFontSize: 12,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey,
                items: [
                  _buildNavItem(
                      icon: ImmoIcons.home,
                      label: "Accueil",
                      isActive: state == PageState.home //_selectedIndex == 0,
                      ),
                  _buildNavItem(
                    icon: ImmoIcons.coeur,
                    label: "Favoris",
                    isActive: state == PageState.forMe, //_selectedIndex == 1,
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: (state.name == PageState.home.name) ? 20 : 40,
                      child: Icon(
                        FontAwesomeIcons.sliders,
                        color: (state.name == PageState.home.name)
                            ? Colors.transparent
                            : Colors.grey.shade300,
                      ),
                    ), // Espace pour le bouton flottant

                    label: "Filtre",
                  ),
                  _buildNavItem(
                      icon: ImmoIcons.visua,
                      label: "Explorer",
                      isActive:
                          state == PageState.explore //_selectedIndex == 3,
                      ),
                  _buildNavItem(
                    icon: ImmoIcons.compte,
                    label: "Compte",
                    isActive: state == PageState.acount, // _selectedIndex == 4,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: (state.name == PageState.home.name)
              ? FloatingActionButton(
                  backgroundColor: AppColors.scafold,
                  onPressed: _showFilterDialog,
                  child: Icon(
                    FontAwesomeIcons.sliders,
                    color: AppColors.primary,
                  ),
                )
              : null,
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required ImmoIcons icon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: isActive
          ? Container(
              height: 40,
              //width: 20,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ImmoIcon(
                icon,
                color: AppColors.primary,
                size: 25,
              ),
            )
          : SizedBox(
              height: 40,
              child: ImmoIcon(
                icon,
                color: Colors.grey.shade600,
                size: 25,
              ),
            ),
      label: label,
    );
  }
}
