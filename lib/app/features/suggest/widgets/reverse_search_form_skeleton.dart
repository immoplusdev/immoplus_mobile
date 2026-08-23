import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Squelette de la page "Que cherchez-vous ?", affiché pendant la
/// vérification d'une recherche active (voir `ReverseSearchPage`) — évite le
/// flash du formulaire vide juste avant la reprise vers la carte des
/// résultats. Purement l'animation Lottie, centrée ; le reste de l'écran
/// garde le même gabarit que le formulaire réel (espace tab bar + bouton)
/// mais reste vide, pour qu'il n'y ait aucun saut visuel à la bascule.
class ReverseSearchFormSkeleton extends StatelessWidget {
  const ReverseSearchFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Lottie.asset(
              'assets/lotties/Not Found.json',
              width: 220,
              height: 220,
              repeat: true,
            ),
          ),
        ),
        // Même gabarit que le divider + bouton du vrai formulaire, sans le
        // rendre visible.
        const SizedBox(height: 81),
      ],
    );
  }
}

/// Squelette de la tab bar (même gabarit que celle construite dans
/// `SearchContainerPage._buildTabBar`) — affiché à la place de la vraie tab
/// bar tant que la recherche active n'a pas fini d'être vérifiée, sans
/// contenu visible, pour éviter un saut de mise en page à la bascule.
class ReverseSearchTabBarSkeleton extends StatelessWidget {
  const ReverseSearchTabBarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: SizedBox(height: 40),
    );
  }
}
