import 'dart:io';
import 'package:flutter/material.dart';

/// Positionne un [FloatingActionButton] au-dessus de la barre de navigation
/// de l'application lorsque la page est imbriquée dans un `Scaffold` parent
/// avec `extendBody: true`.
///
/// Calcule dynamiquement la hauteur selon la plateforme, les insets système
/// (`minViewPadding.bottom` / barre de navigation système) et les marges standards.
class AboveNavBarFabLocation extends FloatingActionButtonLocation {
  final double extraOffset;
  final bool isCenter;

  const AboveNavBarFabLocation({
    this.extraOffset = 0.0,
    this.isCenter = false,
  });

  /// Position par défaut : en bas à droite, au-dessus de la barre de navigation.
  static const FloatingActionButtonLocation endFloat = AboveNavBarFabLocation();

  /// Position centrée au-dessus de la barre de navigation.
  static const FloatingActionButtonLocation centerFloat =
      AboveNavBarFabLocation(isCenter: true);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabWidth = scaffoldGeometry.floatingActionButtonSize.width;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;

    // Calcul dynamique de X (gestion LTR / RTL / Centré)
    final double fabX;
    if (isCenter) {
      fabX = (scaffoldGeometry.scaffoldSize.width - fabWidth) / 2.0;
    } else if (scaffoldGeometry.textDirection == TextDirection.rtl) {
      fabX = kFloatingActionButtonMargin + scaffoldGeometry.minViewPadding.left;
    } else {
      fabX = scaffoldGeometry.scaffoldSize.width -
          fabWidth -
          kFloatingActionButtonMargin -
          scaffoldGeometry.minViewPadding.right;
    }

    // Hauteur totale de dégagement pour la barre de navigation et ses insets système :
    // - Android : Container navbar (80) + insets système (~24-34) + marge FAB (16) = ~125
    // - iOS : Liquid navbar (~70) + safe area (~34) + marge FAB (16) = ~120
    final double dynamicBottomPadding = scaffoldGeometry.minViewPadding.bottom;
    final double baseClearance = Platform.isAndroid ? 125.0 : 115.0;
    final double bottomClearance = dynamicBottomPadding > 0
        ? (Platform.isAndroid ? 80.0 : 70.0) +
            dynamicBottomPadding +
            kFloatingActionButtonMargin
        : baseClearance;

    // Calcul dynamique de Y au-dessus de la bottom nav bar
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        bottomClearance -
        fabHeight -
        extraOffset;

    return Offset(fabX, fabY);
  }
}
