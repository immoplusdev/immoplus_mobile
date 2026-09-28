import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Contrat abstrait définissant l'ensemble des couleurs sémantiques de l'application
/// conformément au Design System officiel Figma (ImmoPlus).
abstract class BaseColors {
  // ── Brand (`immo-brand`) ──
  Color get immoBrandPrimary;
  Color get immoBrandPrimaryPressed;
  Color get immoBrandPrimarySubtle;
  Color get immoBrandSecondary;
  Color get immoBrandAccent;

  // ── Backgrounds & Surfaces (`immo-bg`) ──
  Color get immoBgApp;
  Color get immoBgWhite;
  Color get immoBgAppTinted;
  Color get immoBgSurface;
  Color get immoBgSurfaceMuted;
  Color get immoBgBrandSubtle;
  Color get immoBgInput;
  Color get immoBgAppbar;
  Color get immoBgOverlay;
  Color get immoBgDisabled;

  // ── Typography / Text (`immo-text`) ──
  Color get immoTextPrimary;
  Color get immoTextSecondary;
  Color get immoTextLabel;
  Color get immoTextDisabled;
  Color get immoTextOnBrand;
  Color get immoTextLink;
  Color get immoTextError;

  // ── Borders & Dividers (`immo-border`) ──
  Color get immoBorderDefault;
  Color get immoBorderStrong;
  Color get immoBorderBrand;
  Color get immoBorderBrandSubtle;

  // ── Status & Feedback (`immo-feedback`) ──
  Color get immoFeedbackSuccess;
  Color get immoFeedbackSuccessSubtle;
  Color get immoFeedbackError;
  Color get immoFeedbackErrorSubtle;
  Color get immoFeedbackWarning;
  Color get immoFeedbackWarningSubtle;
  Color get immoFeedbackInfo;
  Color get immoFeedbackInfoSubtle;
  Color get immoFeedbackNeutral;
  Color get immoFeedbackNeutralSubtle;
  Color get immoFeedbackScore;

  // ── Icons (`immo-icon`) ──
  Color get immoIconDefault;
  Color get immoIconMuted;
  Color get immoIconBrand;
  Color get immoIconInactive;

  // ── Controls & Modules (`immo-control`, `immo-module`, `immo-becomepro`) ──
  Color get immoControlCheckbox;
  Color get immoModuleFurnitureSubtle;
  Color get immoBecomeProPrimary;
  Color get immoBecomeProGradientTop;
  Color get immoBecomeProGradientBottom;

  // ── Rétrocompatibilité / Dynamic Access ──
  Color get primary;
  Color get primaryLight;
  Color get primaryDark;
  Color get primarySoft;
  Color get whiteBackground;
  Color get surface;
  Color get textPrimary;
  Color get textSecondary;
  Color get textMuted;
  Color get textInverse;
  Color get textHeading;
  Color get border;
  Color get borderLight;
  Color get borderMedium;
  Color get divider;
  Color get success;
  Color get successLight;
  Color get successDark;
  Color get warning;
  Color get warningLight;
  Color get warningDark;
  Color get error;
  Color get errorLight;
  Color get errorDark;
  Color get info;
  Color get infoLight;
  Color get inactive;
  Color get badgeRecommend;
  Color get badgeUrgent;
  Color get iconPrimary;
  Color get iconSecondary;
  Color get iconBackground;
  Color get previewBackground;
  Color get emptyStateBackground;
  Color get chipBackground;
  Color get inputBackground;
  Color get cardBackground;
  Color get softBlueBackground;
}

/// Implémentation officielle du thème clair (ImmoPlus Light - Figma Design System).
class LightAppColors implements BaseColors {
  const LightAppColors();

  // ── Brand (`immo-brand`) ──
  @override
  Color get immoBrandPrimary => const Color(0xFF2744DE);

  @override
  Color get immoBrandPrimaryPressed => const Color(0xFF0F41D9);

  @override
  Color get immoBrandPrimarySubtle => const Color(0xFFEAF4FE);

  @override
  Color get immoBrandSecondary => const Color(0xFF2072CA);

  @override
  Color get immoBrandAccent => const Color(0xFF65BAF0);

  // ── Backgrounds & Surfaces (`immo-bg`) ──
  @override
  Color get immoBgApp => const Color(0xFFFFFFFF);

  @override
  Color get immoBgWhite => const Color(0xFFFFFFFF);

  @override
  Color get immoBgAppTinted => const Color(0xFFEFF7FF);

  @override
  Color get immoBgSurface => const Color(0xFFFFFFFF);

  @override
  Color get immoBgSurfaceMuted => const Color(0xFFF3F4F7);

  @override
  Color get immoBgBrandSubtle => const Color(0xFFF0F4FD);

  @override
  Color get immoBgInput => const Color(0x29787880);

  @override
  Color get immoBgAppbar => const Color(0xFFFFFFFF);

  @override
  Color get immoBgOverlay => const Color(0x80000000);

  @override
  Color get immoBgDisabled => const Color(0xFFDBDBE0);

  // ── Typography / Text (`immo-text`) ──
  @override
  Color get immoTextPrimary => const Color(0xFF101828);

  @override
  Color get immoTextSecondary => const Color(0xFF667085);

  @override
  Color get immoTextLabel => const Color(0xFF344054);

  @override
  Color get immoTextDisabled => const Color(0xFF98A2B3);

  @override
  Color get immoTextOnBrand => const Color(0xFFFFFFFF);

  @override
  Color get immoTextLink => const Color(0xFF2744DE);

  @override
  Color get immoTextError => const Color(0xFFF04438);

  // ── Borders & Dividers (`immo-border`) ──
  @override
  Color get immoBorderDefault => const Color(0xFFEAECF0);

  @override
  Color get immoBorderStrong => const Color(0xFFD0D5DD);

  @override
  Color get immoBorderBrand => const Color(0xFF2744DE);

  @override
  Color get immoBorderBrandSubtle => const Color(0xFFE0E6F8);

  // ── Status & Feedback (`immo-feedback`) ──
  @override
  Color get immoFeedbackSuccess => const Color(0xFF1CAB5F);

  @override
  Color get immoFeedbackSuccessSubtle => const Color(0xFFE8F6EC);

  @override
  Color get immoFeedbackError => const Color(0xFFF04438);

  @override
  Color get immoFeedbackErrorSubtle => const Color(0xFFFEF3F2);

  @override
  Color get immoFeedbackWarning => const Color(0xFFF79009);

  @override
  Color get immoFeedbackWarningSubtle => const Color(0xFFFFFAE8);

  @override
  Color get immoFeedbackInfo => const Color(0xFF2E5BFF);

  @override
  Color get immoFeedbackInfoSubtle => const Color(0xFFF0F4FD);

  @override
  Color get immoFeedbackNeutral => const Color(0xFF999999);

  @override
  Color get immoFeedbackNeutralSubtle => const Color(0xFFF2F4F7);

  @override
  Color get immoFeedbackScore => const Color(0xFFD4A017);

  // ── Icons (`immo-icon`) ──
  @override
  Color get immoIconDefault => const Color(0xFF344054);

  @override
  Color get immoIconMuted => const Color(0xFF98A2B3);

  @override
  Color get immoIconBrand => const Color(0xFF2744DE);

  @override
  Color get immoIconInactive => const Color(0xFF999999);

  // ── Controls & Modules (`immo-control`, `immo-module`, `immo-becomepro`) ──
  @override
  Color get immoControlCheckbox => const Color(0xFF2744DE);

  @override
  Color get immoModuleFurnitureSubtle => const Color(0x1A4237D6);

  @override
  Color get immoBecomeProPrimary => const Color(0xFF1A3B99);

  @override
  Color get immoBecomeProGradientTop => const Color(0xFF1430F1);

  @override
  Color get immoBecomeProGradientBottom => const Color(0xFF164840);

  // ── Rétrocompatibilité / Dynamic Access ──
  @override
  Color get primary => immoBrandPrimary;

  @override
  Color get primaryLight => const Color(0xFF2548E5);

  @override
  Color get primaryDark => const Color(0xFF143091);

  @override
  Color get primarySoft => immoBrandPrimarySubtle;

  @override
  Color get whiteBackground => immoBgWhite;

  @override
  Color get surface => immoBgSurface;

  @override
  Color get cardBackground => immoBgSurface;

  @override
  Color get softBlueBackground => immoBgBrandSubtle;

  @override
  Color get previewBackground => const Color(0xFFF0F4FF);

  @override
  Color get emptyStateBackground => const Color(0xFFE8EEFF);

  @override
  Color get chipBackground => const Color(0xFFF3F4F6);

  @override
  Color get inputBackground => const Color(0xFFECECEC);

  @override
  Color get textPrimary => immoTextPrimary;

  @override
  Color get textSecondary => immoTextSecondary;

  @override
  Color get textMuted => immoTextSecondary;

  @override
  Color get textInverse => const Color(0xFFFFFFFF);

  @override
  Color get textHeading => const Color(0xFF00122E);

  @override
  Color get border => immoBorderDefault;

  @override
  Color get borderLight => const Color(0xFFF2F2F7);

  @override
  Color get borderMedium => immoBorderStrong;

  @override
  Color get divider => const Color(0xFFE5E7EB);

  @override
  Color get success => immoFeedbackSuccess;

  @override
  Color get successLight => immoFeedbackSuccessSubtle;

  @override
  Color get successDark => const Color(0xFF166534);

  @override
  Color get warning => immoFeedbackWarning;

  @override
  Color get warningLight => immoFeedbackWarningSubtle;

  @override
  Color get warningDark => const Color(0xFFD97706);

  @override
  Color get error => immoFeedbackError;

  @override
  Color get errorLight => immoFeedbackErrorSubtle;

  @override
  Color get errorDark => const Color(0xFF991B1B);

  @override
  Color get info => immoFeedbackInfo;

  @override
  Color get infoLight => immoFeedbackInfoSubtle;

  @override
  Color get inactive => immoFeedbackNeutral;

  @override
  Color get badgeRecommend => const Color(0xFF1A47DF);

  @override
  Color get badgeUrgent => const Color(0xFFF06F26);

  @override
  Color get iconPrimary => immoIconDefault;

  @override
  Color get iconSecondary => immoIconMuted;

  @override
  Color get iconBackground => const Color(0xFFF2F2F2);
}

/// Façade principale d'accès aux couleurs de l'application.
/// Standardisée STRICTEMENT sur le Design System Figma ImmoPlus (Collection `immo-primitives` & `immo-*`).
class AppColors {
  /// Instance courante des couleurs (par défaut Light).
  static BaseColors current = const LightAppColors();

  /// Change le jeu de couleurs courant (ex: bascule Light / Dark).
  static void setColors(BaseColors colors) {
    current = colors;
  }

  // =========================================================================
  // 1. COULEURS SÉMANTIQUES DU DESIGN SYSTEM FIGMA (`immo-*`)
  // =========================================================================

  // ── Brand (`immo-brand`) ──
  static Color get immoBrandPrimary => current.immoBrandPrimary;
  static Color get immoBrandPrimaryPressed => current.immoBrandPrimaryPressed;
  static Color get immoBrandPrimarySubtle => current.immoBrandPrimarySubtle;
  static Color get immoBrandSecondary => current.immoBrandSecondary;
  static Color get immoBrandAccent => current.immoBrandAccent;

  // ── Typography / Text (`immo-text`) ──
  static Color get immoTextPrimary => current.immoTextPrimary;
  static Color get immoTextSecondary => current.immoTextSecondary;
  static Color get immoTextLabel => current.immoTextLabel;
  static Color get immoTextDisabled => current.immoTextDisabled;
  static Color get immoTextOnBrand => current.immoTextOnBrand;
  static Color get immoTextLink => current.immoTextLink;
  static Color get immoTextError => current.immoTextError;

  // ── Backgrounds & Surfaces (`immo-bg`) ──
  static Color get immoBgApp => current.immoBgApp;
  static Color get immoBgWhite => current.immoBgWhite;
  static Color get immoBgAppTinted => current.immoBgAppTinted;
  static Color get immoBgSurface => current.immoBgSurface;
  static Color get immoBgSurfaceMuted => current.immoBgSurfaceMuted;
  static Color get immoBgBrandSubtle => current.immoBgBrandSubtle;
  static Color get immoBgInput => current.immoBgInput;
  static Color get immoBgAppbar => current.immoBgAppbar;
  static Color get immoBgOverlay => current.immoBgOverlay;
  static Color get immoBgDisabled => current.immoBgDisabled;

  // ── Borders & Dividers (`immo-border`) ──
  static Color get immoBorderDefault => current.immoBorderDefault;
  static Color get immoBorderStrong => current.immoBorderStrong;
  static Color get immoBorderBrand => current.immoBorderBrand;
  static Color get immoBorderBrandSubtle => current.immoBorderBrandSubtle;

  // ── Status & Feedback (`immo-feedback`) ──
  static Color get immoFeedbackSuccess => current.immoFeedbackSuccess;
  static Color get immoFeedbackSuccessSubtle => current.immoFeedbackSuccessSubtle;
  static Color get immoFeedbackError => current.immoFeedbackError;
  static Color get immoFeedbackErrorSubtle => current.immoFeedbackErrorSubtle;
  static Color get immoFeedbackWarning => current.immoFeedbackWarning;
  static Color get immoFeedbackWarningSubtle => current.immoFeedbackWarningSubtle;
  static Color get immoFeedbackInfo => current.immoFeedbackInfo;
  static Color get immoFeedbackInfoSubtle => current.immoFeedbackInfoSubtle;
  static Color get immoFeedbackNeutral => current.immoFeedbackNeutral;
  static Color get immoFeedbackNeutralSubtle => current.immoFeedbackNeutralSubtle;
  static Color get immoFeedbackScore => current.immoFeedbackScore;

  // ── Icons (`immo-icon`) ──
  static Color get immoIconDefault => current.immoIconDefault;
  static Color get immoIconMuted => current.immoIconMuted;
  static Color get immoIconBrand => current.immoIconBrand;
  static Color get immoIconInactive => current.immoIconInactive;

  // ── Controls & Modules (`immo-control`, `immo-module`, `immo-becomepro`) ──
  static Color get immoControlCheckbox => current.immoControlCheckbox;
  static Color get immoModuleFurnitureSubtle => current.immoModuleFurnitureSubtle;
  static Color get immoBecomeProPrimary => current.immoBecomeProPrimary;
  static Color get immoBecomeProGradientTop => current.immoBecomeProGradientTop;
  static Color get immoBecomeProGradientBottom => current.immoBecomeProGradientBottom;

  // =========================================================================
  // 2. COULEURS PRIMITIVES FIGMA (`Collection immo-primitives`)
  // =========================================================================

  // ── Blue Scale (`blue/*`) ──
  static const Color blue25 = Color(0xFFF8FDFE);
  static const Color blue40 = Color(0xFFEFF4FF);
  static const Color blue50 = Color(0xFFEEF7FF);
  static const Color blue60 = Color(0xFFE6F3FF);
  static const Color blue75 = Color(0xFFEAF4FE);
  static const Color blue100 = Color(0xFFE6F5FF);
  static const Color blue200 = Color(0xFF8ED3FF);
  static const Color blue300 = Color(0xFF65BAF0);
  static const Color blue500 = Color(0xFF2744DE);
  static const Color blue550 = Color(0xFF2548E5);
  static const Color blue600 = Color(0xFF2072CA);
  static const Color blue700 = Color(0xFF0F41D9);

  // ── Teal Scale (`teal/*`) ──
  static const Color teal50 = Color(0xFFE6F2F2);

  // ── BecomePro Scale (`becomepro/*`) ──
  static const Color becomeproNavy900 = Color(0xFF143091);
  static const Color becomeproNavy800 = Color(0xFF1A3B99);
  static const Color becomeproNavy700 = Color(0xFF1E48A8);
  static const Color becomeproBlue500 = Color(0xFF2E5BFF);
  static const Color becomeproBlue100 = Color(0xFFE0E6F8);
  static const Color becomeproBlue50 = Color(0xFFF0F4FD);

  // ── Gray Scale (`gray/*`, `grey-material/*`) ──
  static const Color gray0 = Color(0xFFFFFFFF);
  static const Color gray100 = Color(0xFFF2F4F7);
  static const Color gray200 = Color(0xFFEAECF0);
  static const Color gray300 = Color(0xFFD0D5DD);
  static const Color gray400 = Color(0xFF98A2B3);
  static const Color gray500 = Color(0xFF667085);
  static const Color gray700 = Color(0xFF344054);
  static const Color gray900 = Color(0xFF101828);
  static const Color gray950 = Color(0xFF171717);
  static const Color gray1000 = Color(0xFF000000);
  static const Color grayInactive = Color(0xFF999999);
  static const Color graySys5 = Color(0xFFE5E5EA);
  static const Color greyMaterial200 = Color(0xFFEEEEEE);
  static const Color greyMaterial400 = Color(0xFFBDBDBD);

  // ── Slate Scale (`slate/*`) ──
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // ── Navy Scale (`navy/*`) ──
  static const Color navy950 = Color(0xFF121224);
  static const Color navy900 = Color(0xFF1A1A2E);
  static const Color navy800 = Color(0xFF26263D);

  // ── Green & Emerald Scale (`green/*`, `emerald/*`) ──
  static const Color green500 = Color(0xFF1CA53F);
  static const Color green50 = Color(0xFFE8F6EC);
  static const Color emerald700 = Color(0xFF0F6E56);
  static const Color emerald50 = Color(0xFFE1F5EE);

  // ── Red Scale (`red/*`) ──
  static const Color red500 = Color(0xFFF04438);
  static const Color red50 = Color(0xFFFEF3F2);
  static const Color red600 = Color(0xFFDC2626);
  static const Color red100 = Color(0xFFFEE2E2);

  // ── Orange & Amber Scale (`orange/*`, `amber/*`) ──
  static const Color orange500 = Color(0xFFF79009);
  static const Color orange50 = Color(0xFFFFFAEB);
  static const Color amber800 = Color(0xFFB54708);
  static const Color amber50 = Color(0xFFFAEDDA);

  // ── Gold Scale (`gold/*`) ──
  static const Color gold400 = Color(0xFFFFD700);
  static const Color gold600 = Color(0xFFD4A017);

  // ── Alphas & Opacity (`alpha/*`) ──
  static const Color alphaBlack50 = Color(0x80000000);
  static const Color alphaFillLight = Color(0x29787880);
  static const Color alphaFillDark = Color(0x5C787880);
  static const Color alphaSky12 = Color(0x1F2195F3);
  static const Color alphaViolet10 = Color(0x1A4227DE);
  static const Color alphaBlack0 = Color(0x00000000);
  static const Color alphaBlack4 = Color(0x0A000000);
  static const Color alphaBlack6 = Color(0x0F000000);
  static const Color alphaBlack12 = Color(0x1F000000);

  // =========================================================================
  // 3. COULEURS SPÉCIFIQUES APPLICATION HORS FIGMA (Avatars, Dégradés Auth)
  // =========================================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color grey = gray500;
  static const Color gray = gray500;
  static const Color red = red500;
  static const Color green = green500;
  static const Color orange = orange500;
  static const Color blue = blue500;
  static const Color amber = orange500;
  static const Color purple = purple7A5AF8;
  static const Color yellow = gold400;
  static const Color pink = Color(0xFFE91E63);
  static const Color pinkAccent = Color(0xFFFF4081);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color lightGreen = Color(0xFF8BC34A);
  static const Color blueGrey = gray400;
  static const Color redAccent = red500;

  // ── Opacités Constantes (Black & White) ──
  static const Color black87 = Color(0xDD000000);
  static const Color black54 = Color(0x8A000000);
  static const Color black45 = Color(0x73000000);
  static const Color black38 = Color(0x61000000);
  static const Color black26 = Color(0x42000000);
  static const Color black12 = Color(0x1F000000);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white54 = Color(0x8AFFFFFF);
  static const Color white38 = Color(0x61FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);

  // ── Social & Paiements ──
  static const Color whatsAppGreen = Color(0xFF25D366);
  static const Color gmailRed = Color(0xFFEA4335);
  static const Color stripePurple = Color(0xFF635BFF);
  static const Color blue2B52F5 = Color(0xFF2B52F5);
  static const Color purple7A5AF8 = Color(0xFF7A5AF8);

  // ── Gradient Auth ──
  static const Color authGradientTop = Color(0xFF64DCFD);
  static const Color authGradientBottom = Color(0xFF156CE4);
  static const Color authGradientWhite = Color(0xFFFFFEFE);

  // ── Monogram Avatar Colors ──
  static const Color avatarGreyLight = Color(0xFFB1B6BE);
  static const Color avatarGreyDark = Color(0xFF9096A0);
  static const Color avatarPinkLight = Color(0xFFFF89A3);
  static const Color avatarPinkDark = Color(0xFFFF6B8B);
  static const Color avatarRedLight = Color(0xFFFF7161);
  static const Color avatarRedDark = Color(0xFFFF523D);
  static const Color avatarOrangeLight = Color(0xFFFFBA53);
  static const Color avatarOrangeDark = Color(0xFFFFA023);
  static const Color avatarYellowLight = Color(0xFFFFD15C);
  static const Color avatarYellowDark = Color(0xFFFFBE28);
  static const Color avatarGreenLight = Color(0xFF80E08E);
  static const Color avatarGreenDark = Color(0xFF5BCB6B);
  static const Color avatarBlueLight = Color(0xFF7DD2FF);
  static const Color avatarBlueDark = Color(0xFF55B9FF);
  static const Color avatarPurpleLight = Color(0xFFB69BFF);
  static const Color avatarPurpleDark = Color(0xFF9872FF);

  // ── Property Amenity Colors ──
  static const Color amenityWifi = Color(0xFFFF5733);
  static const Color amenityAc = Color(0xFF33FFBD);
  static const Color amenityParking = Color(0xFFFFBD33);
  static const Color amenitySalon = Color(0xFFB833FF);
  static const Color amenityCuisine = Color(0xFFFF3385);

  // ── Rétrocompatibilité & Accès Dynamique Thématique ──
  static Color get primary => current.primary;
  static Color get primaryLite => current.primarySoft;
  static Color get scafold => current.whiteBackground;
  static Color get whiteBackground => current.whiteBackground;
  static Color get surface => current.surface;
  static Color get noSelected => current.inactive;
  static Color get success => current.success;
  static Color get successDark => current.successDark;
  static Color get warning => current.warning;
  static Color get warningDark => current.warningDark;
  static Color get error => current.error;
  static Color get errorDark => current.errorDark;
  static Color get info => current.info;
  static Color get previewBackground => current.previewBackground;
  static Color get borderLight => current.borderLight;
  static Color get divider => current.divider;
}
