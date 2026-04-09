import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Widget loading avec animation Lottie pour le ReservationBottomSheet.
/// Reproduit la même taille et structure que ReservationSheetSkeleton.
/// Affiche l'animation immo-loading.json pendant le chargement des données.
class ReservationSheetLottieLoading extends StatelessWidget {
  const ReservationSheetLottieLoading({
    super.key,
    this.lottieSize = 150,
  });

  /// Taille de l'animation Lottie (width et height).
  final double lottieSize;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const fixedBarHeight = 76.0;

    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Stack(
        children: [
          // Zone de contenu : Lottie centré dans tout l'espace au-dessus de la barre
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: fixedBarHeight + bottomInset,
            child: Center(
              child: SizedBox(
                width: lottieSize,
                height: lottieSize,
                child: Lottie.asset(
                  'assets/animations/immo-loading.json',
                  fit: BoxFit.contain,
                  repeat: true,
                  reverse: false,
                ),
              ),
            ),
          ),

          // Bottom button bar (même structure que le skeleton)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
              ),
              // padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              // child: Row(
              //   children: [
              //     // Placeholder pour prix
              //     Container(
              //       width: 100,
              //       height: 40,
              //       decoration: BoxDecoration(
              //         color: Colors.grey[200],
              //         borderRadius: BorderRadius.circular(24),
              //       ),
              //     ),
              //     const SizedBox(width: 12),

              //     // Placeholder pour bouton
              //     Expanded(
              //       child: Container(
              //         height: 48,
              //         decoration: BoxDecoration(
              //           color: Colors.grey[200],
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
