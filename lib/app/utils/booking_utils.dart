import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/booking/widgets/reservation_cancel_reason_bottom_sheet.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_pending_smart.dart';
import 'package:immoplus/app/services/navigation_service.dart';

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
  /// et gère l'appel API, les notifications, l'actualisation, puis le bottom sheet
  /// de collecte des motifs d'annulation.
  static void showCancelReservationDialog({
    required String reservationId,
    ReservationModel? reservation,
    BuildContext? context,
    String? notes,
    VoidCallback? onCancelled,
  }) {
    log("=========reservationId : $reservationId");
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

          final navContext =
              context ?? NavigationService.navigatorKey.currentContext;
          if (navContext != null && navContext.mounted) {
            ReservationCancelReasonBottomSheet.show(
              navContext,
              reservationId: reservationId,
              reservation: reservation,
            );
          }
        } catch (e) {
          ToastUtils.showError(
            description: 'Erreur lors de l\'annulation',
          );
        }
      },
    );
  }
}
