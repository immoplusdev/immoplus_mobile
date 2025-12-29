import 'package:immoplus/app/features/booking_history/booking_history_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/paymebt_history/payment_history_page.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/visit_history/visit_history_page.dart';

enum PushNotificationType {
  auth, // Inscription
  user, // User-related
  reservation, // Réservations
  residence, // Résidences
  bienImmobilier, // Biens immobiliers
  demandeVisite, // Demandes de visite
  payment, // Paiements
  wallet; // Wallet

  /// 🎯 Retourne la route correspondante
  String? getRoute(String? id) {
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

      case PushNotificationType.wallet:
      case PushNotificationType.auth:
      case PushNotificationType.user:
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

      default:
        return null;
    }
  }
}
