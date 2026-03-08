import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget skeleton pour le ReservationBottomSheet pendant le chargement des données.
/// Reproduit exactement la structure et les dimensions du ReservationBottomSheet réel.
class ReservationSheetSkeleton extends StatelessWidget {
  const ReservationSheetSkeleton({
    super.key,
    this.heightFactor = 1.0,
  });

  /// Multiplicateur de hauteur pour réduire/augmenter le skeleton (0.5 = 50%, 1.0 = 100%).
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const fixedBarHeight = 76.0;
    final scrollBottomPadding = fixedBarHeight + bottomInset + 20;

    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 20, 16, scrollBottomPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // PropertyInfo skeleton
                _buildPropertyInfoSkeleton(),
                _verticalSpacer(6),

                // PropertyTabBar skeleton
                _buildPropertyTabBarSkeleton(),

                // Contenu de l'onglet skeleton
                _verticalSpacer(14),
                _buildTabContentSkeleton(),
              ],
            ),
          ),

          // Bottom button bar skeleton
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  // PropertyPrice skeleton - dimensions réelles
                  _buildShimmerBox(
                    width: 100,
                    height: 40,
                    borderRadius: 24,
                  ),
                  const SizedBox(width: 12),

                  // BookNowButton skeleton - dimensions réelles
                  Expanded(
                    child: _buildShimmerBox(
                      height: 48,
                      borderRadius: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reproduit PropertyInfo avec titre et location
  Widget _buildPropertyInfoSkeleton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre (fontSize: 18, fontWeight: w800)
              _buildShimmerBox(width: 220, height: 22, borderRadius: 6),
              _verticalSpacer(4),

              // Location row (fontSize: 12)
              Row(
                children: [
                  _buildShimmerBox(width: 13, height: 13, borderRadius: 2),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildShimmerBox(height: 13, borderRadius: 3),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Close button area
        SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: _buildShimmerBox(width: 24, height: 24, borderRadius: 12),
          ),
        ),
      ],
    );
  }

  /// Reproduit PropertyTabBar avec 3 onglets
  Widget _buildPropertyTabBarSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Tab 1: À propos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildShimmerBox(width: 60, height: 18, borderRadius: 4),
        ),
        // Tab 2: Cartes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildShimmerBox(width: 50, height: 18, borderRadius: 4),
        ),
        // Tab 3: Equipements
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildShimmerBox(width: 80, height: 18, borderRadius: 4),
        ),
      ],
    );
  }

  /// Reproduit le contenu dynamique d'un onglet
  Widget _buildTabContentSkeleton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section titre (Description, etc.)
        _buildShimmerBox(width: 100, height: 18, borderRadius: 5),
        _verticalSpacer(8),

        // Contenu de ligne 1
        _buildShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
        _verticalSpacer(8),

        // Contenu de ligne 2
        _buildShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
        _verticalSpacer(8),

        // Contenu de ligne 3 (plus court)
        _buildShimmerBox(width: 200, height: 16, borderRadius: 4),
        _verticalSpacer(16),

        // Sous-section
        _buildShimmerBox(width: 120, height: 18, borderRadius: 5),
        _verticalSpacer(8),

        // Contenu sous-section
        _buildShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
        _verticalSpacer(8),

        // Contenu sous-section ligne 2
        _buildShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
      ],
    );
  }

  /// Espaceur vertical appliquant le heightFactor
  Widget _verticalSpacer(double height) {
    return SizedBox(height: height * heightFactor);
  }

  /// Widget réutilisable pour les placeholders shimmer
  /// Applique le heightFactor à la hauteur
  Widget _buildShimmerBox({
    required double height,
    double? width,
    double borderRadius = 6,
  }) {
    final adjustedHeight = height * heightFactor;

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width ?? double.infinity,
        height: adjustedHeight,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
