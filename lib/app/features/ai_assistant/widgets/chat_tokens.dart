import 'package:flutter/material.dart';

/// Tokens design du chat IA — source de vérité pour l'UI.
/// Spec : `docs/AI.CONVERSATIONNAL.CHAT.MD` §13 + règles couleur primaire.
class ChatTokens {
  ChatTokens._();

  // Brand — #2744DE est un signal, pas un fond.
  static const Color brand500 = Color(0xFF2744DE);
  static const Color brand600 = Color(0xFF1E38C4); // pressed / hover
  static const Color brandSurface = Color(0xFFEEF1FC); // ~rgba(39,68,222,0.08)
  static Color brandBorder20 = const Color(0xFF2744DE).withValues(alpha: 0.20);
  static Color brandBorder15 = const Color(0xFF2744DE).withValues(alpha: 0.15);

  // Neutres
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color composerSurface = Color(0xFFF7F7F7);
  static const Color neutral100 = Color(0xFFF4F4F5);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color borderStandard = Color(0xFFE5E5E5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color placeholder = Color(0xFFBBBBBB);
  static const Color skeleton = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFF9A9A9A); // inkSecondary
  static const Color readOnlyChipText = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF3F3F46);
  static const Color neutral900 = Color(0xFF1A1A1A); // inkPrimary

  // Sémantique
  static const Color success500 = Color(0xFF16A34A);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color danger500 = Color(0xFFDC2626);
  static const Color dangerSurface = Color(0xFFFEF2F2);
  static const Color scoreHighBg = Color(0xFFDCFCE7);
  static const Color scoreHighFg = Color(0xFF15803D);
  static const Color scoreMidBg = Color(0xFFFEF9C3);
  static const Color scoreMidFg = Color(0xFF92400E);

  // Bandeau de connexion
  static const Color bannerNeutralBg = Color(0xFFF5F5F5);
  static const Color bannerNeutralFg = Color(0xFF9A9A9A);
  static const Color bannerWarnBg = Color(0xFFFEF9EC);
  static const Color bannerWarnFg = Color(0xFF92400E);
  static const Color bannerErrorBg = Color(0xFFFEF2F2);
  static const Color bannerErrorFg = Color(0xFF991B1B);

  // Rayons
  static const double bubbleRadius = 20;
  static const double cardRadius = 16;
  static const double thumbRadius = 10;
  static const double chipRadius = 9999;
  static const double inputRadius = 999;

  // Espacements (système 4)
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;

  // Avatar IA
  static const double avatarSize = 32;
  static const double avatarLogoSize = 22;
  static const double avatarRadius = 10;

  // Thread max width
  static const double threadMaxWidth = 800;

  // Shadow standard
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  // Asset
  static const String aiLogoAsset = 'assets/icon/icon_radius.png';
}
