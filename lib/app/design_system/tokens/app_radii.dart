import 'package:flutter/material.dart';

/// Système standardisé d'arrondis de bordures (BorderRadius) pour ImmoPlus.
class AppRadii {
  AppRadii._();

  // ── Primitives de rayons ──
  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r30 = 30.0;
  static const double rFull = 999.0;

  // ── BorderRadius préconfigurés ──
  static const BorderRadius rounded4 = BorderRadius.all(Radius.circular(r4));
  static const BorderRadius rounded8 = BorderRadius.all(Radius.circular(r8));
  static const BorderRadius rounded10 = BorderRadius.all(Radius.circular(r10));
  static const BorderRadius rounded12 = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius rounded16 = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius rounded20 = BorderRadius.all(Radius.circular(r20));
  static const BorderRadius rounded24 = BorderRadius.all(Radius.circular(r24));
  static const BorderRadius rounded30 = BorderRadius.all(Radius.circular(r30));
  static const BorderRadius roundedFull =
      BorderRadius.all(Radius.circular(rFull));

  // ── BottomSheets / Modales ──
  static const BorderRadius topSheet =
      BorderRadius.vertical(top: Radius.circular(r24));
  static const BorderRadius topSheetLarge =
      BorderRadius.vertical(top: Radius.circular(r30));
}
