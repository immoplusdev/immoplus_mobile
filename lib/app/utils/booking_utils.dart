import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_pending_smart.dart';

enum BookingStatus { upcoming, ongoing, completed }

class BookingUtils {
  static BookingStatus getBookingStatus(DateTime startDate, DateTime endDate) {
    DateTime today = DateTime.now();
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
    DateTime startWithoutTime =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endWithoutTime =
        DateTime(endDate.year, endDate.month, endDate.day);

    if (endWithoutTime.isBefore(todayWithoutTime)) {
      return BookingStatus.completed;
    } else if (startWithoutTime.isAfter(todayWithoutTime)) {
      return BookingStatus.upcoming;
    } else {
      return BookingStatus.ongoing;
    }
  }

  static getStatusText(
      {required DateTime startDate, required DateTime endDate}) {
    switch (getBookingStatus(startDate, endDate)) {
      case BookingStatus.upcoming:
        return 'Séjour à venir';
      case BookingStatus.ongoing:
        return 'Séjour en cours';
      case BookingStatus.completed:
        return 'Séjour terminé';
    }
  }

  /// Affiche le dialogue de confirmation d'annulation d'une réservation client
  /// et gère l'appel API ainsi que les notifications / actualisations associées.
  static void showCancelReservationDialog({
    required String reservationId,
    String? notes,
    VoidCallback? onCancelled,
  }) {
    AppDialog.show(
      title: 'Annuler la réservation',
      description: 'Voulez-vous vraiment annuler cette réservation ?',
      primaryButtonText: 'Oui, annuler',
      secondButtonText: 'Non',
      onPrimary: () async {
        try {
          await getIt<ResidenceRepository>().annulerReservationClient(
            reservationId: reservationId,
            notes: notes ?? 'Annulé par le client',
          );
          ToastUtils.showSuccess(
            description: 'Réservation annulée avec succès',
          );
          ReservationPendingBanner.refresh();
          onCancelled?.call();
        } catch (e) {
          ToastUtils.showError(
            description: 'Erreur lors de l\'annulation',
          );
        }
      },
    );
  }
}
