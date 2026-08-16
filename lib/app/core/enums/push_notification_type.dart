import 'package:immoplus/app/features/alert/pages/alert_propositions_page.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservations_page.dart';
import 'package:immoplus/app/features/booking_history/booking_history_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/paymebt_history/payment_history_page.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/visit_history/visit_history_page.dart';
import 'package:immoplus/app/features/suggest/pages/search_container_page.dart';
import 'package:immoplus/app/features/suggest/pages/suggest_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/user_preference/pages/user_preference_page.dart';
import 'package:immoplus/app/features/my_choice/my_choice_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_list_page.dart';
import 'package:immoplus/app/core/enums/marketing_notification_code.dart';

enum PushNotificationType {
  auth, // Inscription
  user, // User-related
  reservation, // Réservations
  residence, // Résidences
  bienImmobilier, // Biens immobiliers
  demandeVisite, // Demandes de visite
  payment, // Paiements
  wallet, // Wallet
  reservationAccepted, // Pro a accepté → overlay paiement
  reservationRefused, // Pro a refusé → booking history
  newProposal, // Admin a ajouté une proposition → badge Imatch
  alert, // Alerte reçue (match)
  marketing, // Marketing
  ratingRequest; // Demande d'évaluation

  /// 🎯 Retourne la route correspondante
  String? getRoute(String? id, {String? code, String? referenceId}) {
    switch (this) {
      case PushNotificationType.reservation:
        return BookingHistoryPage.route(reservationId: id);

      case PushNotificationType.demandeVisite:
        return VisitHistoryPage.route();

      case PushNotificationType.residence:
        return id != null ? ResidencePage.route(id) : null;

      case PushNotificationType.bienImmobilier:
        return id != null ? EstatePage.route(id) : null;

      case PushNotificationType.payment:
        return PaymentHistoryPage.route();

      case PushNotificationType.reservationAccepted:
        return PendingPaymentReservationsPage.route(reservationId: id);

      case PushNotificationType.reservationRefused:
        return PendingPaymentReservationsPage.route();

      case PushNotificationType.alert:
        return id != null ? AlertPropositionsPage.route(id) : null;

      case PushNotificationType.ratingRequest:
        return id != null ? BookingDetailPage.route(id: id, action: 'rate') : null;

      case PushNotificationType.wallet:
      case PushNotificationType.auth:
      case PushNotificationType.user:
      case PushNotificationType.newProposal:
        return null;
      case PushNotificationType.marketing:
        if (code == null) return null;

        final mCode = MarketingNotificationCode.fromString(code);
        if (mCode == null) return null;

        // Accueil
        if ([
          MarketingNotificationCode.cliOnb07,
          MarketingNotificationCode.cliReeng07,
          MarketingNotificationCode.cliReeng60,
          MarketingNotificationCode.cliSeason01,
          MarketingNotificationCode.cliSocial03,
        ].contains(mCode)) {
          return HomePage.routePath;
        }

        // Recherche / Liste résidences
        if ([
          MarketingNotificationCode.cliOnb03,
          MarketingNotificationCode.cliOnb06,
          MarketingNotificationCode.cliReeng14,
          MarketingNotificationCode.cliReeng30,
          MarketingNotificationCode.cliSeason02,
          MarketingNotificationCode.cliSeason03,
          MarketingNotificationCode.cliSeason04,
          MarketingNotificationCode.cliSocial04,
        ].contains(mCode)) {
          return SearchContainerPage.routePath;
        }

        // Profil / Préférences
        if (mCode == MarketingNotificationCode.cliOnb02) {
          return UserPreferencePage.routePath;
        }

        // Imatch & Favoris
        if ([
          MarketingNotificationCode.cliOnb04,
          MarketingNotificationCode.cliNurt02,
        ].contains(mCode)) {
          return MyChoicePage.routePath;
        }

        // Visite Express
        if (mCode == MarketingNotificationCode.cliOnb05) {
          return VisitHistoryPage.routePath();
        }

        // Fiche Résidence (deep link)
        if ([
          MarketingNotificationCode.cliNurt01,
          MarketingNotificationCode.cliNurtPc01,
          MarketingNotificationCode.cliNurtPc03,
          MarketingNotificationCode.cliSocial01,
        ].contains(mCode)) {
          return referenceId != null
              ? ResidencePage.route(referenceId)
              : SearchContainerPage.routePath;
        }

        // Alertes (deep link)
        if ([
          MarketingNotificationCode.cliNurtAl01,
          MarketingNotificationCode.cliNurtAl02,
          MarketingNotificationCode.cliNurtAl03,
          MarketingNotificationCode.cliNurtAl04,
        ].contains(mCode)) {
          return referenceId != null
              ? AlertPropositionsPage.route(referenceId)
              : AlertListPage.routePath;
        }

        // Détail Réservation (deep link) & Avis / Notation
        if ([
          MarketingNotificationCode.cliResa02,
          MarketingNotificationCode.cliResa03,
          MarketingNotificationCode.cliResa04,
          MarketingNotificationCode.cliResa05,
          MarketingNotificationCode.cliResa06,
        ].contains(mCode)) {
          return referenceId != null
              ? BookingHistoryPage.route(reservationId: referenceId)
              : BookingHistoryPage.routePath();
        }

        return null;
    }
  }

  /// 🎯 Convertir une string en enum
  static PushNotificationType? fromString(String? type) {
    if (type == null) return null;

    switch (type.toLowerCase()) {
      case 'auth':
        return PushNotificationType.auth;

      case 'user':
        return PushNotificationType.user;

      case 'reservation':
        return PushNotificationType.reservation;

      case 'residence':
        return PushNotificationType.residence;

      case 'bien_immobilier':
        return PushNotificationType.bienImmobilier;

      case 'demande_visite':
        return PushNotificationType.demandeVisite;

      case 'payment':
        return PushNotificationType.payment;

      case 'wallet':
        return PushNotificationType.wallet;

      case 'reservation_accepted':
        return PushNotificationType.reservationAccepted;

      case 'reservation_refused':
        return PushNotificationType.reservationRefused;

      case 'new_proposal':
        return PushNotificationType.newProposal;

      case 'alert':
        return PushNotificationType.alert;

      case 'marketing':
        return PushNotificationType.marketing;

      case 'rating_request':
        return PushNotificationType.ratingRequest;

      default:
        return null;
    }
  }
}
