import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Contrat abstrait définissant l'ensemble des couleurs de l'application.
/// Permet de supporter le multi-thème (Light / Dark) et d'éviter les couleurs en dur.
abstract class BaseColors {
  // ── Brand / Primary ──
  Color get primary;
  Color get primaryLight;
  Color get primaryDark;
  Color get primarySoft;
  Color get accent;
  Color get gold;

  // ── Backgrounds & Surfaces ──
  Color get scaffoldBackground;
  Color get whiteBackground;
  Color get surface;
  Color get cardBackground;
  Color get softBlueBackground;
  Color get previewBackground;
  Color get emptyStateBackground;
  Color get chipBackground;
  Color get inputBackground;

  // ── Typography / Text ──
  Color get textPrimary;
  Color get textSecondary;
  Color get textMuted;
  Color get textInverse;
  Color get textHeading;

  // ── Borders & Dividers ──
  Color get border;
  Color get borderLight;
  Color get borderMedium;
  Color get divider;

  // ── Status & Feedback ──
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

  // ── Badges & Tags ──
  Color get badgeRecommend;
  Color get badgeUrgent;

  // ── Icons & Actions ──
  Color get iconPrimary;
  Color get iconSecondary;
  Color get iconBackground;
}

/// Implémentation du thème clair (Light Theme).
class LightAppColors implements BaseColors {
  const LightAppColors();

  // ── Brand / Primary ──
  @override
  Color get primary => const Color(0xFF2744DE);

  @override
  Color get primaryLight => const Color(0xFF2548E5);

  @override
  Color get primaryDark => const Color(0xFF143091);

  @override
  Color get primarySoft => const Color(0xFFEAF4FE);

  @override
  Color get accent => const Color(0xFF4227DE);

  @override
  Color get gold => const Color(0xFFC9A84C);

  // ── Backgrounds & Surfaces ──
  @override
  Color get scaffoldBackground => const Color(0xFFF8FDFE);

  @override
  Color get whiteBackground => const Color(0xFFF8FDFE);

  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get cardBackground => const Color(0xFFFFFFFF);

  @override
  Color get softBlueBackground => const Color(0xFFF0F4FD);

  @override
  Color get previewBackground => const Color(0xFFF0F4FF);

  @override
  Color get emptyStateBackground => const Color(0xFFE8EEFF);

  @override
  Color get chipBackground => const Color(0xFFF3F4F6);

  @override
  Color get inputBackground => const Color(0xFFECECEC);

  // ── Typography / Text ──
  @override
  Color get textPrimary => const Color(0xFF0A1128);

  @override
  Color get textSecondary => const Color(0xFF64748B);

  @override
  Color get textMuted => const Color(0xFF9CA3AF);

  @override
  Color get textInverse => const Color(0xFFFFFFFF);

  @override
  Color get textHeading => const Color(0xFF00122E);

  // ── Borders & Dividers ──
  @override
  Color get border => const Color(0xFFEAECF0);

  @override
  Color get borderLight => const Color(0xFFF2F2F7);

  @override
  Color get borderMedium => const Color(0xFFD0D5DD);

  @override
  Color get divider => const Color(0xFFE5E7EB);

  // ── Status & Feedback ──
  @override
  Color get success => const Color(0xFF1CA53F);

  @override
  Color get successLight => const Color(0xFFDCFCE7);

  @override
  Color get successDark => const Color(0xFF166534);

  @override
  Color get warning => const Color(0xFFF59E0B);

  @override
  Color get warningLight => const Color(0xFFFEF3C7);

  @override
  Color get warningDark => const Color(0xFFD97706);

  @override
  Color get error => const Color(0xFFFF0000);

  @override
  Color get errorLight => const Color(0xFFFEE2E2);

  @override
  Color get errorDark => const Color(0xFF991B1B);

  @override
  Color get info => const Color(0xFF2E5BFF);

  @override
  Color get infoLight => const Color(0xFFEFF6FF);

  @override
  Color get inactive => CupertinoColors.inactiveGray;

  // ── Badges & Tags ──
  @override
  Color get badgeRecommend => const Color(0xFF1A47DF);

  @override
  Color get badgeUrgent => const Color(0xFFF06F26);

  // ── Icons & Actions ──
  @override
  Color get iconPrimary => const Color(0xFF374151);

  @override
  Color get iconSecondary => const Color(0xFF6B7280);

  @override
  Color get iconBackground => const Color(0xFFF2F2F2);
}

/// Implémentation du thème sombre (Dark Theme).
class DarkAppColors implements BaseColors {
  const DarkAppColors();

  @override
  Color get primary => const Color(0xFF3B82F6);

  @override
  Color get primaryLight => const Color(0xFF60A5FA);

  @override
  Color get primaryDark => const Color(0xFF1D4ED8);

  @override
  Color get primarySoft => const Color(0xFF1E293B);

  @override
  Color get accent => const Color(0xFF818CF8);

  @override
  Color get gold => const Color(0xFFEAB308);

  @override
  Color get scaffoldBackground => const Color(0xFF121224);

  @override
  Color get whiteBackground => const Color(0xFF1E1E2E);

  @override
  Color get surface => const Color(0xFF1E1E2E);

  @override
  Color get cardBackground => const Color(0xFF24273A);

  @override
  Color get softBlueBackground => const Color(0xFF1E2235);

  @override
  Color get previewBackground => const Color(0xFF181825);

  @override
  Color get emptyStateBackground => const Color(0xFF232742);

  @override
  Color get chipBackground => const Color(0xFF313244);

  @override
  Color get inputBackground => const Color(0xFF313244);

  @override
  Color get textPrimary => const Color(0xFFCDD6F4);

  @override
  Color get textSecondary => const Color(0xFFA6ADC8);

  @override
  Color get textMuted => const Color(0xFF6C7086);

  @override
  Color get textInverse => const Color(0xFF11111B);

  @override
  Color get textHeading => const Color(0xFFF5E0DC);

  @override
  Color get border => const Color(0xFF45475A);

  @override
  Color get borderLight => const Color(0xFF313244);

  @override
  Color get borderMedium => const Color(0xFF585B70);

  @override
  Color get divider => const Color(0xFF45475A);

  @override
  Color get success => const Color(0xFFA6E3A1);

  @override
  Color get successLight => const Color(0xFF1E3A2F);

  @override
  Color get successDark => const Color(0xFFA6E3A1);

  @override
  Color get warning => const Color(0xFFF9E2AF);

  @override
  Color get warningLight => const Color(0xFF3C3524);

  @override
  Color get warningDark => const Color(0xFFF9E2AF);

  @override
  Color get error => const Color(0xFFF38BA8);

  @override
  Color get errorLight => const Color(0xFF3B1E2B);

  @override
  Color get errorDark => const Color(0xFFF38BA8);

  @override
  Color get info => const Color(0xFF89B4FA);

  @override
  Color get infoLight => const Color(0xFF1E283D);

  @override
  Color get inactive => const Color(0xFF6C7086);

  @override
  Color get badgeRecommend => const Color(0xFF3B82F6);

  @override
  Color get badgeUrgent => const Color(0xFFF97316);

  @override
  Color get iconPrimary => const Color(0xFFCDD6F4);

  @override
  Color get iconSecondary => const Color(0xFFA6ADC8);

  @override
  Color get iconBackground => const Color(0xFF313244);
}

/// Façade principale d'accès aux couleurs de l'application.
/// Fournit un accès statique direct, une instance `current` interchangeable
/// et assure une rétrocompatibilité complète avec le code existant.
class AppColors {
  /// Instance courante des couleurs (par défaut Light).
  static BaseColors current = const LightAppColors();

  /// Change le jeu de couleurs courant (ex: bascule Light / Dark).
  static void setColors(BaseColors colors) {
    current = colors;
  }

  // ── Primitives & Constantes Globales ──
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color white60 = Colors.white60;
  static const Color white54 = Colors.white54;
  static const Color white38 = Colors.white38;
  static const Color white30 = Colors.white30;
  static const Color white24 = Colors.white24;
  static const Color white12 = Colors.white12;
  static const Color white10 = Colors.white10;

  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color black54 = Colors.black54;
  static const Color black45 = Colors.black45;
  static const Color black38 = Colors.black38;
  static const Color black26 = Colors.black26;
  static const Color black12 = Colors.black12;

  static const Color transparent = Colors.transparent;

  // ── Palette Material (Nuances Standard) ──
  static const MaterialColor grey = Colors.grey;
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  static const MaterialColor blueGrey = Colors.blueGrey;
  static const Color blueGrey50 = Color(0xFFECEFF1);
  static const Color blueGrey100 = Color(0xFFCFD8DC);
  static const Color blueGrey200 = Color(0xFFB0BEC5);
  static const Color blueGrey300 = Color(0xFF90A4AE);
  static const Color blueGrey400 = Color(0xFF78909C);
  static const Color blueGrey500 = Color(0xFF607D8B);
  static const Color blueGrey600 = Color(0xFF546E7A);
  static const Color blueGrey700 = Color(0xFF455A64);
  static const Color blueGrey800 = Color(0xFF37474F);
  static const Color blueGrey900 = Color(0xFF263238);

  static const MaterialColor red = Colors.red;
  static const Color redAccent = Colors.redAccent;
  static const Color red50 = Color(0xFFFFEBEE);
  static const Color red100 = Color(0xFFFFCDD2);
  static const Color red200 = Color(0xFFEF9A9A);
  static const Color red300 = Color(0xFFE57373);
  static const Color red400 = Color(0xFFEF5350);
  static const Color red500 = Color(0xFFF44336);
  static const Color red600 = Color(0xFFE53935);
  static const Color red700 = Color(0xFFD32F2F);
  static const Color red800 = Color(0xFFC62828);
  static const Color red900 = Color(0xFFB71C1C);

  static const MaterialColor orange = Colors.orange;
  static const Color orangeAccent = Colors.orangeAccent;
  static const Color orange50 = Color(0xFFFFF3E0);
  static const Color orange100 = Color(0xFFFFE0B2);
  static const Color orange200 = Color(0xFFFFCC80);
  static const Color orange300 = Color(0xFFFFB74D);
  static const Color orange400 = Color(0xFFFFA726);
  static const Color orange500 = Color(0xFFFF9800);
  static const Color orange600 = Color(0xFFFB8C00);
  static const Color orange700 = Color(0xFFF57C00);
  static const Color orange800 = Color(0xFFEF6C00);
  static const Color orange900 = Color(0xFFE65100);

  static const MaterialColor amber = Colors.amber;
  static const Color amberAccent = Colors.amberAccent;
  static const Color amber50 = Color(0xFFFFF8E1);
  static const Color amber100 = Color(0xFFFFECB3);
  static const Color amber200 = Color(0xFFFFE082);
  static const Color amber300 = Color(0xFFFFD54F);
  static const Color amber400 = Color(0xFFFFCA28);
  static const Color amber500 = Color(0xFFFFC107);
  static const Color amber600 = Color(0xFFFFB300);
  static const Color amber700 = Color(0xFFFFA000);
  static const Color amber800 = Color(0xFFFF8F00);
  static const Color amber900 = Color(0xFFFF6F00);

  static const MaterialColor yellow = Colors.yellow;
  static const Color yellowAccent = Colors.yellowAccent;
  static const Color yellow50 = Color(0xFFFFFDE7);
  static const Color yellow100 = Color(0xFFFFF9C4);
  static const Color yellow200 = Color(0xFFFFF59D);
  static const Color yellow300 = Color(0xFFFFF176);
  static const Color yellow400 = Color(0xFFFFEE58);
  static const Color yellow500 = Color(0xFFFFEB3B);
  static const Color yellow600 = Color(0xFFFDD835);
  static const Color yellow700 = Color(0xFFFBC02D);
  static const Color yellow800 = Color(0xFFF9A825);
  static const Color yellow900 = Color(0xFFF57F17);

  static const MaterialColor green = Colors.green;
  static const Color greenAccent = Colors.greenAccent;
  static const Color green50 = Color(0xFFE8F5E9);
  static const Color green100 = Color(0xFFC8E6C9);
  static const Color green200 = Color(0xFFA5D6A7);
  static const Color green300 = Color(0xFF81C784);
  static const Color green400 = Color(0xFF66BB6A);
  static const Color green500 = Color(0xFF4CAF50);
  static const Color green600 = Color(0xFF43A047);
  static const Color green700 = Color(0xFF388E3C);
  static const Color green800 = Color(0xFF2E7D32);
  static const Color green900 = Color(0xFF1B5E20);

  static const MaterialColor blue = Colors.blue;
  static const Color blueAccent = Colors.blueAccent;
  static const Color blue50 = Color(0xFFE3F2FD);
  static const Color blue100 = Color(0xFFBBDEFB);
  static const Color blue200 = Color(0xFF90CAF9);
  static const Color blue300 = Color(0xFF64B5F6);
  static const Color blue400 = Color(0xFF42A5F5);
  static const Color blue500 = Color(0xFF2196F3);
  static const Color blue600 = Color(0xFF1E88E5);
  static const Color blue700 = Color(0xFF1976D2);
  static const Color blue800 = Color(0xFF1565C0);
  static const Color blue900 = Color(0xFF0D47A1);

  static const MaterialColor purple = Colors.purple;
  static const Color purpleAccent = Colors.purpleAccent;
  static const MaterialColor deepPurple = Colors.deepPurple;
  static const Color deepPurpleAccent = Colors.deepPurpleAccent;
  static const MaterialColor teal = Colors.teal;
  static const Color tealAccent = Colors.tealAccent;
  static const MaterialColor cyan = Colors.cyan;
  static const Color cyanAccent = Colors.cyanAccent;
  static const MaterialColor indigo = Colors.indigo;
  static const Color indigoAccent = Colors.indigoAccent;
  static const MaterialColor pink = Colors.pink;
  static const Color pinkAccent = Colors.pinkAccent;
  static const MaterialColor brown = Colors.brown;
  static const MaterialColor deepOrange = Colors.deepOrange;
  static const Color deepOrangeAccent = Colors.deepOrangeAccent;
  static const MaterialColor lime = Colors.lime;
  static const Color limeAccent = Colors.limeAccent;

  // ── Constantes Hex Claires Fréquentes ──
  static const Color customBlue = Color(0xFF2744DE);
  static const Color blue4227DE = Color(0xFF4227DE);
  static const Color blue2548E5 = Color(0xFF2548E5);
  static const Color lightBlue = Color(0xFF2072CA);
  static const Color blue65BAF0 = Color(0xFF65BAF0);
  static const Color blue0F41D9 = Color(0xFF0F41D9);
  static const Color blue8ED3FF = Color(0xFF8ED3FF);
  static const Color blueE6F2F2 = Color(0xFFE6F2F2);
  static const Color darkBluePrimary = Color(0xFF1A3B99);
  static const Color gradientTop = Color(0xFF143091);
  static const Color gradientBottom = Color(0xFF1E48A8);

  // ── Backgrounds & Neutrals ──
  static const Color previewBackground = Color(0xFFF0F4FF);
  static const Color infoBgSoftBlue = Color(0xFFF0F4FD);
  static const Color softBlueBg = Color(0xFFEFF6FF);
  static const Color emptyStateBlueBg = Color(0xFFE8EEFF);
  static const Color skySoftBlueBg = Color(0xFFE0F2FE);
  static const Color bgEFF4FF = Color(0xFFEFF4FF);
  static const Color bgF1F5FD = Color(0xFFF1F5FD);
  static const Color bgFEF3F2 = Color(0xFFFEF3F2);
  static const Color bgF4F3FF = Color(0xFFF4F3FF);
  static const Color bgFFFAEB = Color(0xFFFFFAEB);
  static const Color surfaceLight = Color(0xFFF9FAFB);
  static const Color bgF7F8FA = Color(0xFFF7F8FA);
  static const Color bgFBFBFB = Color(0xFFFBFBFB);
  static const Color iconBgLight = Color(0xFFF2F2F2);
  static const Color tagBgLight = Color(0xFFF3F4F6);

  // ── Text / Obsidian / Grays ──
  static const Color text0B1C30 = Color(0xFF0B1C30);
  static const Color textPrimaryDark = Color(0xFF101828);
  static const Color textHeadingObsidian = Color(0xFF00122E);
  static const Color textObsidian = Color(0xFF0A1128);
  static const Color textNavyDeep = Color(0xFF0F1E36);
  static const Color textCharcoal = Color(0xFF1A1A2E);
  static const Color textSlate = Color(0xFF1F2937);
  static const Color text1E293B = Color(0xFF1E293B);
  static const Color text334155 = Color(0xFF334155);
  static const Color textDarkGray = Color(0xFF374151);
  static const Color textDark = Color(0xFF222222);
  static const Color text0D0D0D = Color(0xFF0D0D0D);
  static const Color text1E1E1E = Color(0xFF1E1E1E);
  static const Color text1F1F1F = Color(0xFF1F1F1F);
  static const Color text111827 = Color(0xFF111827);
  static const Color text344054 = Color(0xFF344054);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textSecondaryMedium = Color(0xFF667085);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLightGray = Color(0xFF6B7280);
  static const Color text8A94A6 = Color(0xFF8A94A6);
  static const Color text94A3B8 = Color(0xFF94A3B8);
  static const Color textBrandMuted = Color(0xFF9CA3AF);
  static const Color text98A2B3 = Color(0xFF98A2B3);
  static const Color textA3A3A3 = Color(0xFFA3A3A3);
  static const Color textCBD5E1 = Color(0xFFCBD5E1);
  static const Color textE2E8F0 = Color(0xFFE2E8F0);
  static const Color textF1F5F9 = Color(0xFFF1F5F9);
  static const Color shadowA6ADB9 = Color(0xFFA6ADB9);
  static const Color shadowBEBEBE = Color(0xFFBEBEBE);
  static const Color unselectedGray = Color(0xFFAAAAAA);

  // ── Borders & Dividers ──
  static const Color borderLight = Color(0xFFF2F2F7);
  static const Color borderLightGray = Color(0xFFEAECF0);
  static const Color borderF2F4F7 = Color(0xFFF2F4F7);
  static const Color borderMediumGray = Color(0xFFD0D5DD);
  static const Color borderD1D5DB = Color(0xFFD1D5DB);
  static const Color borderD6E2FB = Color(0xFFD6E2FB);
  static const Color borderSoftBlue = Color(0xFFE0E6F8);
  static const Color borderSubtle = Color(0xFFE5E7EB);
  static const Color borderEAECEF = Color(0xFFEAECEF);
  static const Color dividerLight = Color(0xFFF0F0F0);
  static const Color borderE0 = Color(0xFFE0E0E0);
  // ignore: constant_identifier_names
  static const Color D5D5D5 = Color(0xFFD5D5D5);
  // ignore: constant_identifier_names
  static const Color E9E9E9 = Color(0xFFE9E9E9);
  // ignore: constant_identifier_names
  static const Color ECECEC = Color(0xFFECECEC);
  // ignore: constant_identifier_names
  static const Color E6F5FF = Color(0xFFE6F5FF);
  // ignore: constant_identifier_names
  static const Color F2F2F2 = Color(0xFFF2F2F2);
  static const Color color8A8A86 = Color(0xFF8A8A86);
  static const Color color65BAF0 = Color(0xFF65BAF0);

  // ── Accents, Auth & Feedback ──
  static const Color goldLuxury = Color(0xFFC9A84C);
  static const Color tagGoldBg = Color(0x26C9A84C); // rgba(201, 168, 76, 0.15)
  static const Color goldStar = Color(0xFFFFD700);
  static const Color infoBorderBlue = Color(0xFF2E5BFF);
  static const Color stripePurple = Color(0xFF635BFF);
  static const Color blue2B52F5 = Color(0xFF2B52F5);
  static const Color purple7A5AF8 = Color(0xFF7A5AF8);
  static const Color whatsAppGreen = Color(0xFF25D366);
  static const Color gmailRed = Color(0xFFEA4335);
  static const Color green1CA53F = Color(0xFF1CA53F);
  static const Color green68D197 = Color(0xFF68D197);
  static const Color greenActiveBg = Color(0xFFDCFCE7);
  static const Color greenActiveText = Color(0xFF166534);
  static const Color redFF0000 = Color(0xFFFF0000);
  static const Color redLightBg = Color(0xFFFEE2E2);
  static const Color redDarkText = Color(0xFF991B1B);
  static const Color errorF04438 = Color(0xFFF04438);
  static const Color orangeWarning = Color(0xFFF57C00);
  static const Color orangeRating = Color(0xFFFF9800);
  static const Color amberF79009 = Color(0xFFF79009);
  static const Color amberB54708 = Color(0xFFB54708);
  static const Color amberFFBB00 = Color(0xFFFFBB00);
  static const Color amberPendingBg = Color(0xFFFEF3C7);
  static const Color amberPendingText = Color(0xFFD97706);
  static const Color badgeRecommendBlue = Color(0xFF1A47DF);
  static const Color badgeUrgentOrange = Color(0xFFF06F26);
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

  // ── Rétrocompatibilité & Accès Dynamique ──
  static Color get primary => current.primary;
  static Color get primaryLite => current.primarySoft;
  static Color get scafold => current.scaffoldBackground;
  static Color get whiteBackground => current.whiteBackground;
  static Color get scaffoldBackgroundColor => current.scaffoldBackground;
  static Color get noSelected => current.inactive;
  static Color get success => current.success;
  static Color get warning => current.warning;
  static Color get error => current.error;
  static Color get info => current.info;
}
