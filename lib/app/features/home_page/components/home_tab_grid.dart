import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_search_page.dart';
import 'package:immoplus/app/features/my_choice/my_choice_page.dart';
import 'package:immoplus/app/features/suggest/pages/search_result_page.dart';

/// Grille de 6 cards remplaçant les anciens onglets natifs de l'accueil
/// (voir new.hoome.feed.md). Chaque card navigue vers une page séparée —
/// ce n'est plus un switch de contenu in-page.
///
/// Exposée aussi en deux moitiés ([HomeTabGridRowOne]/[HomeTabGridRowTwo])
/// pour permettre à `HomeSearchAppbar` d'épingler la 1ère ligne (avec la
/// barre de recherche) pendant que le reste défile derrière.
class HomeTabGrid extends StatelessWidget {
  const HomeTabGrid({super.key});

  static const double horizontalPadding = 20.0;
  static const double rowGap = 16.0;
  static const double cardHeight = 109;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeTabGridRowOne(),
        const SizedBox(height: rowGap),
        const HomeTabGridRowTwo(),
      ],
    );
  }
}

/// Première ligne (Séjour, Logement, Hotel) — épinglée avec la barre de
/// recherche dans `HomeSearchAppbar`.
class HomeTabGridRowOne extends StatelessWidget {
  const HomeTabGridRowOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: HomeTabGrid.horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildCards(context).sublist(0, 3),
      ),
    );
  }
}

/// Deuxième ligne (Bien, Carte, Demenager) — défile normalement sous la
/// première ligne épinglée.
class HomeTabGridRowTwo extends StatelessWidget {
  const HomeTabGridRowTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: HomeTabGrid.horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildCards(context).sublist(3, 6),
      ),
    );
  }
}

List<Widget> _buildCards(BuildContext context) {
  return [
    _HomeTabCard(
      imagePath: 'assets/img/onglets/sejour.png',
      labelLine1: 'Trouver un',
      labelLine2: 'Séjour',
      icon: Iconsax.calendar,
      borderColor: const Color(0xFFFFEEF6),
      badgeColor: const Color(0xFFFF5C9E),
      onTap: () => context.push(
        SearchResultPage.routePath,
        extra: {
          'category': HomeTab.residence.category,
          'displayText': 'Résidences'
        },
      ),
    ),
    _HomeTabCard(
      imagePath: 'assets/img/onglets/logement.png',
      labelLine1: 'Trouver un',
      labelLine2: 'Logement',
      icon: Iconsax.home_2,
      borderColor: const Color(0xFFF9DBDD),
      badgeColor: const Color(0xFFE85C6B),
      onTap: () => context.push(
        SearchResultPage.routePath,
        extra: {
          'category': HomeTab.location.category,
          'displayText': 'Location'
        },
      ),
    ),
    _HomeTabCard(
      imagePath: 'assets/img/onglets/hotel.png',
      labelLine1: 'Trouver un',
      labelLine2: 'Hôtel',
      icon: Iconsax.building,
      borderColor: const Color(0xFFDAFCE7),
      badgeColor: const Color(0xFF34C77B),
      onTap: () => context.push(HotelSearchPage.routePath),
    ),
    _HomeTabCard(
      imagePath: 'assets/img/onglets/bien.png',
      labelLine1: 'Acheter un',
      labelLine2: 'Bien',
      icon: Iconsax.buildings_2,
      borderColor: const Color(0xFFFAE5CF),
      badgeColor: const Color(0xFFFF9F43),
      onTap: () => context.push(
        SearchResultPage.routePath,
        extra: {'category': HomeTab.bien.category, 'displayText': 'Biens'},
      ),
    ),
    _HomeTabCard(
      imagePath: 'assets/img/onglets/carte.png',
      labelLine1: 'Explorer la',
      labelLine2: 'Carte',
      icon: Iconsax.location,
      borderColor: const Color(0xFFF4F3CD),
      badgeColor: const Color(0xFFF2C94C),
      onTap: () => context.push('/map'),
    ),
    _HomeTabCard(
      imagePath: 'assets/img/onglets/demenager.png',
      labelLine1: 'Je veux',
      labelLine2: 'Déménager',
      icon: Iconsax.truck_fast,
      borderColor: const Color(0xFFE8E1FF),
      badgeColor: const Color(0xFF8C6FF5),
      onTap: () {
        final sessionManager = getIt<SessionManager>();
        if (sessionManager.currentUser == null) {
          context.pushNamed(
            AuthenticationPage.name,
            extra: (
              callback: () => context.goNamed(MyChoicePage.name),
              popUntilRouteName: null,
            ) as AuthRedirectData,
          );
        } else {
          context.goNamed(MyChoicePage.name);
        }
      },
    ),
  ];
}

class _HomeTabCard extends StatelessWidget {
  const _HomeTabCard({
    required this.imagePath,
    required this.labelLine1,
    required this.labelLine2,
    required this.icon,
    required this.borderColor,
    required this.badgeColor,
    required this.onTap,
  });

  final String imagePath;
  final String labelLine1;
  final String labelLine2;
  final IconData icon;
  final Color borderColor;
  final Color badgeColor;
  final VoidCallback? onTap;

  static const double _width = 94.31;
  static const double _height = 109;
  static const double _imageSize = 48;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: _width,
        height: _height,
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 17),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(145, 165, 255, 0.08),
              offset: Offset(1, 4),
              blurRadius: 23.4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: _imageSize,
              height: _imageSize,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(
                      imagePath,
                      width: _imageSize,
                      height: _imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(color: Colors.transparent),
                    ),
                  ),
                  Positioned(
                    bottom: -6,
                    right: -6,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4(
                        0.98, -0.22, 0, 0, //
                        0.19, 0.98, 0, 0, //
                        0, 0, 1, 0, //
                        0, 0, 0, 1, //
                      ),
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: borderColor,
                          shape: BoxShape.circle,
                        ),
                        child: Transform.rotate(
                          angle: -15.75 * math.pi / 180,
                          child: Icon(icon, size: 10, color: badgeColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                labelLine1,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  height: 1.1,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                labelLine2,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
