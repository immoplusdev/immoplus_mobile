import 'dart:developer' as dev;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:immoplus/app/features/fast-track-book/reservation_pending_smart.dart';

/// Socket.IO temps réel pour le namespace /reservations (côté client).
///
/// Connecté une seule fois par session utilisateur (voir
/// [SessionManager.saveUser] / [SessionManager.getCurrentUser] /
/// [SessionManager.clearSession]) — jamais par écran, le routage serveur se
/// fait par room `user:${userId}` déduite du JWT.
///
/// Le client n'émet jamais rien sur ce socket : il écoute uniquement
/// `reservation:status_updated` et déclenche un refresh via les notifiers
/// déjà utilisés pour les push OneSignal (`ReservationPendingBanner`).
class ReservationSocketService {
  ReservationSocketService._();

  static io.Socket? _socket;

  /// Statuts qui concernent le client (cf. table §3 du guide WebSocket) :
  /// propriétaire a accepté/refusé, ou paiement validé. `client_annule_reservation`
  /// est émis vers le propriétaire, pas vers le client — volontairement exclu.
  static const Set<String> _clientRelevantStatuses = {
    'en_attente_paiement_client',
    'proprietaire_annule_reservation',
    'valide',
  };

  static bool get isConnected => _socket?.connected ?? false;

  /// À appeler à chaque fois qu'un accessToken (re)devient disponible :
  /// login, inscription, refresh token, ou chargement de session au démarrage.
  static void connect(String? accessToken) {
    if (accessToken == null || accessToken.isEmpty) return;

    final baseUrl = (dotenv.env['API_BASE_URL'] ?? '').trim();
    if (baseUrl.isEmpty) return;

    _socket?.dispose();
    _socket = io.io(
      '$baseUrl/reservations',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .disableAutoConnect()
          .setReconnectionAttempts(8)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(8000)
          .build(),
    );

    _socket!.onConnect((_) => dev.log('connecté', name: 'ReservationSocket'));
    _socket!.onDisconnect(
        (reason) => dev.log('déconnecté: $reason', name: 'ReservationSocket'));
    _socket!.onConnectError(
        (err) => dev.log('erreur connexion: $err', name: 'ReservationSocket'));

    _socket!.on('reservation:status_updated', _onStatusUpdated);

    _socket!.connect();
  }

  static void _onStatusUpdated(dynamic data) {
    if (data is! Map) return;
    final newStatus = data['newStatus']?.toString();
    dev.log('reservation:status_updated → $newStatus',
        name: 'ReservationSocket');
    if (newStatus != null && _clientRelevantStatuses.contains(newStatus)) {
      ReservationPendingBanner.onPushReceived();
    }
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
