import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/request_path.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

enum OPERATOR_NAME {
  Orange,
  MTN,
  Moov,
  Ecobank,
  Wave,
  Cash,
}

class Utils {
  static String formatDatOnly({required DateTime dateTime}) {
    String formattedDate = DateFormat("dd MMMM yyy").format(dateTime);
    return formattedDate;
  }

  static String formatTimeOnly({required DateTime dateTime}) {
    String formattedDate = DateFormat("HH'h':mm").format(dateTime);
    return formattedDate;
  }

  static void makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
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

  /// URL vidéo à partir de l'ID. En dev (FLAVOR=dev) utilise l'URL dev [RequestPath.baseUrl].
  /// En prod utilise l'URL prod. Retourne null si baseUrl ou id vide → "Impossible de lire la vidéo".
  static String? getVideoPath({required String id}) {
    final baseUrl = RequestPath.baseUrl.trim();
    final videoId = id.trim();
    if (baseUrl.isEmpty || videoId.isEmpty) return null;
    return "$baseUrl/files/videos/raw/public/$videoId";
  }

  static Widget getImageWidget({required String id}) => CachedNetworkImage(
        imageUrl: "${RequestPath.baseUrl}/files/raw/public/$id",
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
    if (type == ServicesCollection.reservations.name) {
      return 'Réservation';
    } else if (type == ServicesCollection.demandes_visites.name) {
      return 'Demande de visite';
    }
    return 'Réservation';
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
      case 'en_cours_validation_user':
        return 'En attente de paiement';
      case 'en_cours_validation_admin':
        return 'En cours de validation';
      case 'successful':
        return 'Finalisé';
      case 'valide':
        return 'Validé';
      case 'failed':
        return 'Échoué';
      case 'rejete':
        return 'Rejeté';
      case 'paye':
        return 'Payé';
      case 'en_attente_validation':
        return 'En cours de validation';
      case 'non_paye':
        return 'Non payé';

      default:
        return 'No Element';
    }
  }

  static Widget getServiceStatusIcon(String status) {
    switch (status) {
      case 'en_cours_validation_user':
        return const Icon(FontAwesomeIcons.hourglass, color: Colors.orange);
      case 'en_cours_validation_admin':
        return const Icon(FontAwesomeIcons.hourglass, color: Colors.orange);
      case 'successful':
        return const Icon(FontAwesomeIcons.circleCheck, color: Colors.green);
      case 'valide':
        return const Icon(FontAwesomeIcons.circleCheck, color: Colors.green);
      case 'failed':
        return const Icon(FontAwesomeIcons.circleXmark, color: Colors.red);
      case 'rejete':
        return const Icon(FontAwesomeIcons.circleXmark, color: Colors.red);
      case 'paye':
        return const Icon(FontAwesomeIcons.circleCheck, color: Colors.green);
      case 'en_attente_validation':
        return const Icon(FontAwesomeIcons.hourglass, color: Colors.orange);
      case 'non_paye':
        return const Icon(FontAwesomeIcons.circleXmark, color: Colors.red);
      default:
        return const Icon(FontAwesomeIcons.hourglass, color: Colors.grey);
    }
  }

  static Color getServiceStatusColor(String status) {
    switch (status) {
      case 'en_cours_validation_user':
        return Colors.orange;
      case 'en_cours_validation_admin':
        return Colors.orange;
      case 'successful':
        return Colors.green;
      case 'valide':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'rejete':
        return Colors.red;
      case 'paye':
        return Colors.green;
      case 'en_attente_validation':
        return Colors.orange;
      case 'non_paye':
        return Colors.red;
      default:
        return Colors.grey;
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

  static String getTypeVisite(String status) {
    switch (status) {
      case 'normal':
        return 'Visite normal';
      case 'express':
        return 'Vite express';
      default:
        return 'Emty';
    }
  }

  static Color getTypeVisiteColor(String status) {
    switch (status) {
      case 'normal':
        return Colors.purple;
      case 'express':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String getTimeAgo({required DateTime dateTime}) {
    return timeago.format(dateTime);
  }

  static String formatDate({required DateTime dateTime}) {
    String formattedDate = DateFormat('dd/MM/yyy').format(dateTime);
    return formattedDate;
  }

  static String formatDateTime({required DateTime dateTime}) {
    String formattedDate =
        DateFormat("dd MMMM yyy  à HH'h':mm").format(dateTime);
    return formattedDate;
  }

  static Color getStatusColor({required String status}) {
    if (status == 'successful') {
      return CupertinoColors.systemGreen;
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
    }
    return CupertinoColors.inactiveGray;
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

  // static sendMail({required ProductDetailModel e}) async {
  //   log(ConfigModel.singleton.contactEmail!);
  //   final Uri emailLaunchUri = Uri(
  //     scheme: 'mailto',
  //     path: ConfigModel.singleton.contactEmail,
  //     query: _encodeQueryParameters(<String, String>{
  //       'subject': "Intéressé par l'article ${e.name} ID : ${e.id}",
  //     }),
  //   );

  //   await launchUrl(emailLaunchUri);
  // }

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

  static bookingMail({required String id}) async {
    // log(ConfigModel.singleton.contactEmail!);
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: "email@gmail.com",
      query: _encodeQueryParameters(<String, String>{
        'subject': "Réservation d'identifiant: $id",
      }),
    );

    await launchUrl(emailLaunchUri);
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

  // static authentificationPopup({required BuildContext context}) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     backgroundColor: HexColor("#121224"),
  //     enableDrag: true,
  //     context: context,
  //     builder: (context) => FractionallySizedBox(
  //       heightFactor: 1,
  //       child: ClipRRect(
  //           borderRadius: BorderRadius.circular(30), child: const LoginPage()),
  //     ),
  //   );
  // }

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

    // Formater la partie entière avec des espaces comme séparateur de milliers
    String formattedAmount = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]} ',
    );

    // Ajouter la partie décimale si elle existe
    if (hasDecimal) {
      formattedAmount += '.${parts[1]}';
    }

    // Ajouter le symbole de la monnaie XOF
    formattedAmount += ' XOF';

    return formattedAmount;
  }

  static String simpleFormatCurrency(dynamic amount) {
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

    return formattedAmount;
  }

  void formatPhoneNumber(PhoneNumber number) async {
    String parsableNumber = await PhoneNumber.getParsableNumber(number);
    // Supprimer le signe "+" si présent
    if (parsableNumber.startsWith('+')) {
      parsableNumber = parsableNumber.substring(1);
    }
    // Insérer le tiret après le code pays
    String formattedNumber = parsableNumber.replaceFirstMapped(
      RegExp(r'^(\d{3})(\d+)$'),
      (Match m) => '${m[1]}-${m[2]}',
    );
    print(formattedNumber); // Affiche : 225-0701710065
  }

  static DateTime toDateTime(String? dateString) {
    try {
      return DateTime.parse(dateString!);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Convertit une heure au format String (ex: "09:00" ou "09h00") en TimeOfDay
  TimeOfDay parseTime(String timeString) {
    try {
      // Nettoyer la chaîne
      String cleaned = timeString.trim().toUpperCase();

      // Vérifier si c'est un format AM/PM
      bool isPM = cleaned.contains('PM');
      bool isAM = cleaned.contains('AM');

      // Extraire la partie numérique
      String timePart =
          cleaned.replaceAll('AM', '').replaceAll('PM', '').trim();

      List<String> parts = timePart.split(':');
      int hour = int.parse(parts[0]);
      int minute = parts.length > 1 ? int.parse(parts[1]) : 0;

      // Conversion du format 12h au format 24h
      if (isPM && hour != 12) {
        hour += 12; // 1 PM = 13h, 2 PM = 14h, etc.
      } else if (isAM && hour == 12) {
        hour = 0; // 12 AM = 00h (minuit)
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      log('Erreur lors du parsing de l\'heure: $timeString - $e');
      // Valeur par défaut si parsing échoue
      return const TimeOfDay(hour: 12, minute: 0);
    }
  }
    static String cleanMarkdown(String markdownText) {
  String text = markdownText;

  text = text.replaceAll(RegExp(r'#{1,6}\s*'), '');
  text = text.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1');
  text = text.replaceAll(RegExp(r'__(.*?)__'), r'$1');
  text = text.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
  text = text.replaceAll(RegExp(r'_(.*?)_'), r'$1');
  text = text.replaceAll(RegExp(r'^\s*[-*]\s+', multiLine: true), '');
  text = text.replaceAll(RegExp(r'^\s*\d+\.\s+', multiLine: true), '');
  text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'$1');
  text = text.replaceAll(RegExp(r'\n{2,}'), ' ');
  text = text.replaceAll('\n', ' ');
  text = text.replaceAll(RegExp(r' {2,}'), ' ').trim();

  if (text.isNotEmpty) {
    text = text[0].toUpperCase() + text.substring(1);
  }

  if (text.isNotEmpty && !'.!?'.contains(text[text.length - 1])) {
    text = '$text.';
  }

  return text;
}

  static copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
