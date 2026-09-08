import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Système centralisé de typographie pour l'application ImmoPlus.
///
/// Standardise l'ensemble des polices sur **Plus Jakarta Sans** avec une échelle
/// de tailles et poids cohérente (H1 à H4, Body, Label, Caption).
class AppTypography {
  AppTypography._();

  /// Nom de la police principale de l'application
  static const String fontFamily = 'Plus Jakarta Sans';

  // ==========================================
  // HEADINGS / TITRES
  // ==========================================

  /// H1 / Display Large - 30px, Bold (w700)
  /// Utilisé pour les très grands titres d'accueil, bannières d'impact.
  static TextStyle get h1 => GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      );

  /// H2 / Display Medium - 24px, Bold (w700)
  /// Utilisé pour les titres d'écrans principaux et sections majeures.
  static TextStyle get h2 => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
      );

  /// H3 / Title Large - 20px, SemiBold (w600)
  /// Utilisé pour les titres de fiches, modales, dialogues.
  static TextStyle get h3 => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      );

  /// H4 / Title Medium - 18px, SemiBold (w600)
  /// Utilisé pour les titres de cartes et sous-sections.
  static TextStyle get h4 => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.3,
      );

  /// Title Small - 16px, SemiBold (w600)
  /// Utilisé pour les en-têtes d'items de listes et petits titres de groupes.
  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  // ==========================================
  // BODY / TEXTE COURANT
  // ==========================================

  /// Body Large - 16px, Regular (w400)
  /// Texte de premier plan, champs de saisie, paragraphes importants.
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Body Large SemiBold - 16px, SemiBold (w600)
  static TextStyle get bodyLargeSemiBold => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  /// Body Medium - 14px, Regular (w400)
  /// Texte standard par défaut dans toute l'application.
  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  /// Body Medium Medium - 14px, Medium (w500)
  static TextStyle get bodyMediumMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
      );

  /// Body Medium SemiBold - 14px, SemiBold (w600)
  static TextStyle get bodyMediumSemiBold => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.45,
      );

  /// Body Small - 12px, Regular (w400)
  /// Descriptions secondaires, métadonnées, textes d'aide.
  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  /// Body Small Medium - 12px, Medium (w500)
  static TextStyle get bodySmallMedium => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  /// Body Small SemiBold - 12px, SemiBold (w600)
  static TextStyle get bodySmallSemiBold => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // ==========================================
  // LABELS / BOUTONS / BADGES
  // ==========================================

  /// Button / Label Large - 15px, SemiBold (w600)
  /// Utilisé dans les boutons principaux et éléments d'action.
  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  /// Label Large - 14px, SemiBold (w600)
  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  /// Label Medium - 12px, Medium (w500)
  /// Badges, puces (chips), indicateurs d'état.
  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  /// Caption / Label Small - 11px, Regular (w400)
  /// Timestamps, petites notes, compteurs d'images.
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      );

  /// Caption Medium - 11px, Medium (w500)
  static TextStyle get captionMedium => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  /// Caption SemiBold - 11px, SemiBold (w600)
  static TextStyle get captionSemiBold => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  /// Micro - 10px, Regular (w400)
  static TextStyle get micro => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      );

  /// Micro Bold - 10px, Bold (w700)
  static TextStyle get microBold => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      );

  // ==========================================
  // THEME DATA GENERATORS
  // ==========================================

  /// Génère le TextTheme officiel pour le thème clair
  static TextTheme lightTextTheme([TextTheme? base]) {
    final theme = base ?? ThemeData.light().textTheme;
    return GoogleFonts.plusJakartaSansTextTheme(theme).copyWith(
      displayLarge: h1.copyWith(color: AppColors.text0B1C30),
      displayMedium: h2.copyWith(color: AppColors.text0B1C30),
      displaySmall: h3.copyWith(color: AppColors.text0B1C30),
      headlineMedium: h4.copyWith(color: AppColors.text0B1C30),
      headlineSmall: titleSmall.copyWith(color: AppColors.text0B1C30),
      titleLarge: h3.copyWith(color: AppColors.text0B1C30),
      titleMedium: h4.copyWith(color: AppColors.text0B1C30),
      titleSmall: titleSmall.copyWith(color: AppColors.text0B1C30),
      bodyLarge: bodyLarge.copyWith(color: AppColors.text1E293B),
      bodyMedium: bodyMedium.copyWith(color: AppColors.text334155),
      bodySmall: bodySmall.copyWith(color: AppColors.textMuted),
      labelLarge: button.copyWith(color: AppColors.text0B1C30),
      labelMedium: labelMedium.copyWith(color: AppColors.textMuted),
      labelSmall: caption.copyWith(color: AppColors.text94A3B8),
    );
  }

  /// Génère le TextTheme officiel pour le thème sombre
  static TextTheme darkTextTheme([TextTheme? base]) {
    final theme = base ?? ThemeData.dark().textTheme;
    return GoogleFonts.plusJakartaSansTextTheme(theme).copyWith(
      displayLarge: h1.copyWith(color: Colors.white),
      displayMedium: h2.copyWith(color: Colors.white),
      displaySmall: h3.copyWith(color: Colors.white),
      headlineMedium: h4.copyWith(color: Colors.white),
      headlineSmall: titleSmall.copyWith(color: Colors.white),
      titleLarge: h3.copyWith(color: Colors.white),
      titleMedium: h4.copyWith(color: Colors.white),
      titleSmall: titleSmall.copyWith(color: Colors.white),
      bodyLarge: bodyLarge.copyWith(color: AppColors.textF1F5F9),
      bodyMedium: bodyMedium.copyWith(color: AppColors.textE2E8F0),
      bodySmall: bodySmall.copyWith(color: AppColors.text94A3B8),
      labelLarge: button.copyWith(color: Colors.white),
      labelMedium: labelMedium.copyWith(color: AppColors.textCBD5E1),
      labelSmall: caption.copyWith(color: AppColors.textMuted),
    );
  }
}

/// Extension d'aide sur BuildContext pour accéder facilement aux styles
extension AppTypographyContextExt on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
