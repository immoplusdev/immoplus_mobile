import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReverseSearchSocketService {
  io.Socket? _socket;

  final _propositionController =
      StreamController<ReverseSearchProposition>.broadcast();
  Stream<ReverseSearchProposition> get onProposition =>
      _propositionController.stream;

  final _statusController = StreamController<String>.broadcast();
  Stream<String> get onStatus => _statusController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String? accessToken) {
    if (accessToken == null || accessToken.isEmpty) return;

    final baseUrl = (dotenv.env['API_BASE_URL'] ?? '').trim();
    if (baseUrl.isEmpty) return;

    _socket?.dispose();
    _socket = io.io(
      '$baseUrl/reverse-searches',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .disableAutoConnect()
          .setReconnectionAttempts(8)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(8000)
          .build(),
    );

    _socket!.onConnect((_) => dev.log('connecté', name: 'ReverseSearchSocket'));
    _socket!.onDisconnect((reason) =>
        dev.log('déconnecté: $reason', name: 'ReverseSearchSocket'));
    _socket!.onConnectError((err) =>
        dev.log('erreur connexion: $err', name: 'ReverseSearchSocket'));

    _socket!.on('reverse_search:proposition_disponible', (data) {
      if (data is Map<String, dynamic>) {
        try {
          final proposition = ReverseSearchProposition.fromJson(data);
          _propositionController.add(proposition);
        } catch (e) {
          dev.log('Erreur parsing proposition: $e', name: 'ReverseSearchSocket');
        }
      }
    });

    _socket!.on('reverse_search:annulee', (_) => _statusController.add('annulee'));
    _socket!.on('reverse_search:selection_expiree', (_) => _statusController.add('selection_expiree'));
    _socket!.on('reverse_search:paiement_echec', (_) => _statusController.add('paiement_echec'));

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
