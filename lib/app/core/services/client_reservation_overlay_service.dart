import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:injectable/injectable.dart';

import 'client_reservation_overlay_widget.dart';

enum ClientReservationOverlayState {
  waitingProprietaire,
  waitingPayment,
}

@lazySingleton
class ClientReservationOverlayService {
  final ResidenceRepository _repository;
  final SessionManager _sessionManager;

  ClientReservationOverlayService(this._repository, this._sessionManager);

  OverlayEntry? _overlayEntry;

  /// Point d'entrée principal — à appeler depuis initState (addPostFrameCallback)
  /// et depuis les notifications push
  Future<void> checkAndShowOverlay(BuildContext context) async {
    if (_sessionManager.currentUser == null) return;

    // 1. Vérifier s'il y a une réservation en attente de réponse propriétaire
    final pendingProprietaire =
        await _repository.getLatestPendingProprietaireReponse();

    if (pendingProprietaire != null) {
      _showOverlay(
        context,
        pendingProprietaire,
        ClientReservationOverlayState.waitingProprietaire,
      );
      return;
    }

    // 2. Sinon, vérifier s'il y a une réservation en attente de paiement client
    try {
      final result = await _repository.getReservationsEnAttentePaiement(
        page: 1,
        perPage: 1,
      );
      if (result.data.isNotEmpty) {
        _showOverlay(
          context,
          result.data.first,
          ClientReservationOverlayState.waitingPayment,
        );
        return;
      }
    } catch (_) {}

    dismissOverlay();
  }

  /// Appelé à la réception d'une notification reservation_accepted
  Future<void> showPaymentOverlay(
    BuildContext context,
    ReservationModel reservation,
  ) async {
    _showOverlay(
      context,
      reservation,
      ClientReservationOverlayState.waitingPayment,
    );
  }

  void _showOverlay(
    BuildContext context,
    ReservationModel reservation,
    ClientReservationOverlayState state,
  ) {
    dismissOverlay();
    _overlayEntry = OverlayEntry(
      builder: (_) => ClientReservationOverlayWidget(
        reservation: reservation,
        overlayState: state,
        onDismiss: dismissOverlay,
        onPayNow: () {
          dismissOverlay();
          NavigationService.navigatorKey.currentContext?.pushNamed(
            OperatorsSelectorPage.name,
            extra: PaymentPageAdapter(
              itemId: reservation.id,
              collection: ProductType.reservations.name,
              amount: reservation.montantTotalReservation.toInt(),
            ),
          );
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void dismissOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
