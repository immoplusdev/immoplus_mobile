import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Système standardisé d'espacements et paddings pour ImmoPlus.
/// Basé sur une grille modulaire de 4px / 8px.
class AppSpacing {
  AppSpacing._();

  // ── Primitives de tailles ──
  static const double xxxs = 2.0;
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double huge = 48.0;

  // ── Marges de page par défaut ──
  static const double pagePadding = 16.0;
  static const double cardPadding = 16.0;

  // ── Gaps préconfigurés ──
  static const Gap gap2 = Gap(xxxs);
  static const Gap gap4 = Gap(xxs);
  static const Gap gap8 = Gap(xs);
  static const Gap gap12 = Gap(sm);
  static const Gap gap16 = Gap(md);
  static const Gap gap20 = Gap(lg);
  static const Gap gap24 = Gap(xl);
  static const Gap gap32 = Gap(xxl);
  static const Gap gap40 = Gap(xxxl);
  static const Gap gap48 = Gap(huge);

  // ── Insets préconfigurés ──
  static const EdgeInsets edgeAll4 = EdgeInsets.all(xxs);
  static const EdgeInsets edgeAll8 = EdgeInsets.all(xs);
  static const EdgeInsets edgeAll12 = EdgeInsets.all(sm);
  static const EdgeInsets edgeAll16 = EdgeInsets.all(md);
  static const EdgeInsets edgeAll20 = EdgeInsets.all(lg);
  static const EdgeInsets edgeAll24 = EdgeInsets.all(xl);

  static const EdgeInsets edgeH16 = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets edgeH20 = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets edgeH24 = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets edgeV8 = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets edgeV12 = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets edgeV16 = EdgeInsets.symmetric(vertical: md);
}
