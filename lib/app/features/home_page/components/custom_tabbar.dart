import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/immo_icons.dart';

class CustomTabBar extends StatelessWidget {
  CustomTabBar({
    super.key,
    required this.iconSize,
    required this.controller,
  });
  final double iconSize;
  final TabController controller;
  final EdgeInsetsGeometry _iconMargin = EdgeInsets.only(bottom: 3);
  //final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SliverAppBarDelegate(
        TabBar(
          automaticIndicatorColorAdjustment: true,
          padding: EdgeInsets.zero,
          // onTap: (index) async {
          //   Vibrate.feedback(FeedbackType.light);
          //   // Ajoutez ici le code que vous souhaitez exécuter lorsque l'utilisateur
          //   // change d'onglet.
          // },
          indicatorPadding: EdgeInsets.only(bottom: 10),
          labelPadding: EdgeInsets.zero,
          dividerHeight: 0,

          indicatorWeight: 3,
          //dividerHeight: 20,
          controller: controller,
          //indicatorPadding: EdgeInsets.symmetric(vertical: 8),
          indicatorColor:
              AppColors.primary, //Theme.of(context).colorScheme.primary,
          labelColor:
              AppColors.primary, //Theme.of(context).colorScheme.primary,
          unselectedLabelColor: AppColors.noSelected,

          indicatorSize: TabBarIndicatorSize.label,
          //tabAlignment: TabAlignment.center,
          //isScrollable: true,
          labelStyle:
              GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),

          tabs: [
            Tab(
              iconMargin: _iconMargin,
              icon: ImmoIcon(
                ImmoIcons.recent,
                color: (controller.index == 0)
                    ? AppColors.primary
                    : AppColors.noSelected,
                size: iconSize,
              ),
              text: 'Récent',
            ),
            Tab(
              iconMargin: _iconMargin,
              icon: ImmoIcon(
                ImmoIcons.resi,
                color: (controller.index == 1)
                    ? AppColors.primary
                    : AppColors.noSelected,
                size: iconSize,
              ),
              text: 'Résidence',
            ),
            Tab(
              iconMargin: _iconMargin,
              icon: ImmoIcon(
                ImmoIcons.meubles,
                color: (controller.index == 2)
                    ? AppColors.primary
                    : AppColors.noSelected,
                size: iconSize,
              ),
              text: 'Meuble',
            ),

            Tab(
              iconMargin: _iconMargin,
              icon: ImmoIcon(
                ImmoIcons.location,
                color: (controller.index == 3)
                    ? AppColors.primary
                    : AppColors.noSelected,
                size: iconSize,
              ),
              text: 'Location',
            ),
            Tab(
              iconMargin: _iconMargin,
              icon: ImmoIcon(
                ImmoIcons.service,
                color: (controller.index == 4)
                    ? AppColors.primary
                    : AppColors.noSelected,
                size: iconSize,
              ),
              text: 'Service',
            ),
            Tab(
              iconMargin: _iconMargin,
              icon: ImmoIcon(
                ImmoIcons.terrain,
                color: (controller.index == 5)
                    ? AppColors.primary
                    : AppColors.noSelected,
                size: iconSize,
              ),
              text: 'Achat',
            ),
            //Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
      ),
      floating: false,
      pinned: true,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
