import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_model.dart';
import 'package:immoplus/app/features/account/account_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';

import 'package:intl/intl.dart';

enum PageState {
  home,
  explore,
  history,
  map,
  acount,
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
    PageState.acount: AccountPage(),
    PageState.history: Container(), //HistoricalPage(),
  };
  //static ConfigModel? configApp;
  static ValueNotifier<bool> buildNotifier = ValueNotifier<bool>(true);
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
