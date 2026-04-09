import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_model.dart';
import 'package:immoplus/app/features/account/account_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

import 'package:intl/intl.dart';

enum PageState {
  home,
  vivre,
  explore,
  history,
  map,
  account,
  forMe,
}

enum LogmentType {
  villa,
  appartement,
  maison,
}

enum TypeDemandeVisite {
  express,
  normal,
}

enum ServicesCollection {
  demandes_visites,
  reservations,
}

class Constantes {
  static String tempPage = '/home';
  static var globalkey = GlobalKey<NavigatorState>();
  static const String visitToAsk = "visit_to_ask";
  static const String toOrder = 'to_order';
  static const String service = 'service';
  static const String toContact = 'to_contact';
  static const String mooving = 'mooving';
  static const String booking = 'booking';
  static String mapToken = dotenv.env['GOOGLE_KEY'] ?? '';
  static late BuildContext appContext;
  static test() {}

  BuildContext context;
  Constantes({required this.context});
  static ColorScheme colorScheme = ColorScheme(
    primary: HexColor("#2072ca"),
    secondary: const Color(0xFFABABAB),
    surface: const Color.fromARGB(255, 166, 173, 180),
    error: const Color(0xFFFFFFFF),
    onPrimary: const Color(0xFFFFFFFF),
    onSecondary: HexColor("04b4fc"),
    onSurface: const Color(0xFF3E3C3C),
    onError: const Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static Map<PageState, Widget> navigationPage = {
    PageState.home: const HomePage(),
    PageState.explore: Container(), //SearchPage(),
    PageState.map: Container(), //MapViewer(),
    PageState.account: AccountPage(),
    PageState.history: Container(), //HistoricalPage(),
  };
  //static ConfigModel? configApp;
  static ValueNotifier<bool> buildNotifier = ValueNotifier<bool>(true);
  /// Masquer la bottom navigation bar (ex: quand le sheet Réserver est ouvert).
  static ValueNotifier<bool> hideBottomNavNotifier = ValueNotifier<bool>(false);
  static ValueNotifier<VilleModel> villeUser =
      ValueNotifier<VilleModel>(const VilleModel(id: "0000", name: ''));

  static String url = "api.immoplus.ci";
  static Shadow textShadow = const Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 10.0,
      color: Color.fromRGBO(0, 0, 0, 1));
}

enum ProductType {
  visit_to_ask,

  to_order,

  to_contact,

  service,

  booking,
  demandes_visites,
  reservations,
}

enum ServiceType {
  commande,
  service,
  visite,
}

enum ServiceStatus {
  pending,
  successful,
  failed,
  en_cours_validation_user,
  en_cours_validation_admin,
}

enum PaymentStatus {
  paye,
  non_paye,
  payment_required,
  processing,
  action_required,
  pending,
  failed,
  successful,
}

enum DeliveryMethod {
  moto,
  camion,
}

enum ShippingStatus {
  successful,
  failed,
  en_cours_recuperation,
  en_cours_livraison,
}

enum NotificationCollection {
  payments,
}

int? toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

List<double> listToDouble(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map<double>((e) {
      if (e is double) return e;
      if (e is int) return e.toDouble();
      if (e is String) return double.tryParse(e) ?? 0;
      return 0;
    }).toList();
  }
  return [];
}

const maxPriceLimit = 3000000;
const minPriceLimit = 100;

// === FURNITURE MODULE CONSTANTS ===
class FurnitureUIConstants {
  // Spacing (multiples de 4)
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Hero Header
  static const double heroHeightPercent = 0.42;
  static const double heroMinHeight = 360.0;

  // Sticky Bar
  static const double stickyBarHeight = 72.0;
  static const double stickyBarButtonGap = 12.0;
  static const double secondaryButtonWidthPercent = 0.35;
  static const double primaryButtonWidthPercent = 0.65;

  // Typography Sizes
  static const double fontSizeH1 = 24.0;
  static const double fontSizeH2 = 28.0;
  static const double fontSizeSubtitle = 16.0;
  static const double fontSizeBody = 15.0;
  static const double fontSizeMetadata = 13.0;
  static const double fontSizeChipLabel = 14.0;

  // Line Heights
  static const double lineHeightH1 = 32.0;
  static const double lineHeightH2 = 36.0;
  static const double lineHeightBody = 22.0;

  // Elevation & Shadows (pour BoxShadow)
  static List<BoxShadow> get shadowLight => [
        BoxShadow(
          color: AppColors.blue4227DE.withValues(alpha: 0.08),
          offset: const Offset(0, 2),
          blurRadius: 8,
        ),
      ];

  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: AppColors.blue4227DE.withValues(alpha: 0.12),
          offset: const Offset(0, 4),
          blurRadius: 16,
        ),
      ];

  static List<BoxShadow> get shadowHeavy => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          offset: const Offset(0, 8),
          blurRadius: 24,
        ),
      ];
}
