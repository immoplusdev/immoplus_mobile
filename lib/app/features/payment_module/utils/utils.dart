import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/request_path.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

enum OPERATOR_NAME { Orange, MTN, Moov, Ecobank, Wave, Cash, visa }

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class Utils {
  static String formatDate({required DateTime dateTime}) {
    String formattedDate = DateFormat('dd/MM/yyy').format(dateTime);
    return formattedDate;
  }

  static String formatDateTime({required DateTime dateTime}) {
    String formattedDate =
        DateFormat("dd MMMM yyy  à HH'h':mm").format(dateTime);
    return formattedDate;
  }

  static String getCurrentLocation() =>
      AppRouter.router.routerDelegate.currentConfiguration.uri.toString();

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static ImageProvider getImage({required String id}) =>
      CachedNetworkImageProvider(
        "${RequestPath.baseUrl}/files/raw/public/$id",
      );
  static String getImagePath({required String id}) =>
      "${RequestPath.baseUrl}/files/raw/public/$id";

  static Widget getImageWidget({required String id}) => CachedNetworkImage(
        imageUrl: "${RequestPath.baseUrl}/api/file//files/raw/public/$id",
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: (Colors.grey[300])!,
          highlightColor: Colors.white,
          period: const Duration(milliseconds: 600),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage('https://via.placeholder.com/500x400'),
              )),
        ),
      );
  static String getActionText(String type) {
    switch (type) {
      case Constantes.visitToAsk:
        return 'VISITER';
      case Constantes.booking:
        return 'RESERVER';
      case Constantes.toOrder:
        return 'COMMANDER';
      case Constantes.service:
        return 'DEMANDER LE SERVICE';
      case Constantes.toContact:
        return 'CONTACTER';

      default:
        return 'No Element';
    }
  }

  static String getServiceName(String type) {
    switch (type) {
      case Constantes.visitToAsk:
        return 'Demande de visite';
      case Constantes.booking:
        return 'Réservation';
      case Constantes.toOrder:
        return 'Commande';
      case Constantes.service:
        return 'Demande de service';
      case Constantes.toContact:
        return 'Contacter';

      default:
        return 'No Element';
    }
  }

  static String getPoductTarget(String type) {
    switch (type) {
      case Constantes.visitToAsk:
        return 'À visiter';
      case Constantes.booking:
        return 'À réserver';
      case Constantes.toOrder:
        return 'À commander';
      case Constantes.service:
        return 'Service';
      case Constantes.toContact:
        return 'Nous contacter';

      default:
        return 'No Element';
    }
  }

  static String getServiceStatus(String status) {
    switch (status) {
      case 'non_valide':
        return 'Non validé';
      case 'rejecte':
        return 'Rejeté';
      case 'validé':
        return 'Validé';
      case 'en_cours_validation_user':
        return 'En attente de paiement';
      case 'en_cours_validation_admin':
        return 'En cours de validation';
      case 'successful':
        return 'Finalisé';
      case 'failed':
        return 'Échoué';
      case 'paye':
        return 'Payé';
      case 'non_paye':
        return 'Non payé';
      default:
        return 'No Element';
    }
  }

  static String getShippingStatus(String? status) {
    switch (status) {
      case 'en_cours_recuperation':
        return 'En attente de récupération';
      case 'en_cours_livraison':
        return 'En cours de livreaison';
      case 'successful':
        return 'Livré';
      case 'failed':
        return 'Non livré';
      default:
        return 'En attente de récupération';
    }
  }

  static String getTimeAgo({required DateTime dateTime}) {
    return timeago.format(dateTime);
  }

  // static String formatDate({required DateTime dateTime}) {
  //   String formattedDate = DateFormat('d/MM/yyy').format(dateTime);
  //   return formattedDate;
  // }

  static Color getStatusColor({required String status}) {
    if (status == 'successful') {
      return CupertinoColors.systemGreen;
    } else if (status == 'paye') {
      return CupertinoColors.systemGreen;
    } else if (status == 'non_paye') {
      return CupertinoColors.systemRed;
    } else if (status == 'en_cours_validation_admin') {
      return CupertinoColors.systemGrey2;
    } else if (status == 'en_cours_validation_user') {
      return CupertinoColors.activeOrange;
    } else if (status == 'en_cours_recuperation') {
      return CupertinoColors.systemGrey2;
    } else if (status == 'en_cours_livraison') {
      return Colors.green.shade200;
    } else if (status == 'failed') {
      return CupertinoColors.systemRed;
    } else if (status == 'canceled') {
      return CupertinoColors.destructiveRed;
    } else if (status == 'payment_required') {
      return CupertinoColors.destructiveRed;
    }
    return CupertinoColors.inactiveGray;
  }

  static call() async {
    await launchUrl(Uri(
      scheme: 'tel',
      path: "",
    ));
  }

  static String getSSD({required String paymentType}) {
    if (paymentType == 'orange') {
      return "#144*82#";
    } else if (paymentType == 'moov') {
      return "*155#";
    } else if (paymentType == 'mtn') {
      return "*133#";
    }
    return "XXXX";
  }

  static ssdPayment({required String paymentType}) async {
    String code = getSSD(paymentType: paymentType);
    await launchUrl(Uri(
      scheme: 'tel',
      path: code,
    ));
  }

  static bookingMail({required String id}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: "ConfigModel.singleton.contactEmail",
      query: _encodeQueryParameters(<String, String>{
        'subject': "Réservation d'identifiant: $id",
      }),
    );

    await launchUrl(emailLaunchUri);
  }

  static sendMail({required ResidenceModel e}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: "ConfigModel.singleton.contactEmail",
      query: _encodeQueryParameters(<String, String>{
        'subject': "Intéressé par l'article ${e.nom} ID : ${e.id}",
      }),
    );

    await launchUrl(emailLaunchUri);
  }

  static whatsapp(
      {required String phoneNumber, String defaultMessage = ''}) async {
    var contact = phoneNumber;
    var androidUrl = "whatsapp://send?phone=$contact&text=$defaultMessage";

    var iosUrl = "https://wa.me/$contact?text=${Uri.parse(defaultMessage)}";

    print(iosUrl);

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl),
            mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse(androidUrl),
            mode: LaunchMode.externalApplication);
      }
    } on Exception {
      EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  static String getOperatorImagePath({String? name}) {
    switch (name!.toLowerCase()) {
      case 'cash':
        return 'assets/icon/cash.png';
      case 'mtn':
        return 'assets/icon/mtn.jpeg';
      case 'moov':
        return 'assets/icon/moov.png';
      case 'orange':
        return 'assets/icon/om.png';
      case 'ecobank':
        return 'assets/icon/eco.jpeg';
      case 'wave':
        return 'assets/icon/wave.png';
      default:
        return 'assets/icon/icon.png';
    }
  }

  static String getNextActionText({String? name}) {
    switch (name!.toLowerCase()) {
      case 'cash':
        return "rien";
      case 'mtn':
        return "Composez ***133#** et choisissez l'option **«Valider retrait»** pour approuver la demande.";
      case 'moov':
        return "Composez ***155#** et choisissez l'option **«Valider retrait»** pour approuver la demande.";
      case 'orange':
        return 'Composez **#144*82#** pour obtenir un code de confirmation';
      case 'ecobank':
        return 'assets/icon/eco.jpeg';
      case 'wave':
        return "Valider depuis l'application wave";
      default:
        return 'pas d\'action';
    }
  }

  static IconData getNotificationIcon(String collection) {
    if (collection == NotificationCollection.payments.name) {
      return FontAwesomeIcons.coins;
    }
    return FontAwesomeIcons.ring;
  }

  static String formatCurrency(dynamic amount) {
    // Convertir le montant en une chaîne de caractères
    String amountString = amount.toString();

    // Vérifier s'il y a une partie décimale
    bool hasDecimal = amountString.contains('.');

    // Séparer la partie entière et la partie décimale
    List<String> parts = amountString.split('.');

    // Formater la partie entière avec le séparateur de milliers
    String formattedAmount = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    // Ajouter la partie décimale si elle existe
    if (hasDecimal) {
      formattedAmount += '.${parts[1]}';
    }

    // Ajouter le symbole de la monnaie
    formattedAmount += ' F';

    return formattedAmount;
  }

 
}
