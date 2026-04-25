import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:immoplus/app/core/network/utils/session_manager.dart';

enum ChatConnectionState {
  connecting,
  connected,
  reconnecting,
  disconnected,
  unauthenticated,
  error,
}

class ChatSocketService {
  ChatSocketService(this._sessionManager);

  final SessionManager _sessionManager;
  io.Socket? _socket;

  final StreamController<ChatConnectionState> _stateController =
      StreamController<ChatConnectionState>.broadcast();

  Stream<ChatConnectionState> get connectionState => _stateController.stream;

  bool get isConnected => _socket?.connected ?? false;

  final StreamController<Map<String, dynamic>> _typing =
      StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _streamStart =
      StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _streamChunk =
      StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _streamEnd =
      StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _errorEvent =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get onTyping => _typing.stream;
  Stream<Map<String, dynamic>> get onStreamStart => _streamStart.stream;
  Stream<Map<String, dynamic>> get onStreamChunk => _streamChunk.stream;
  Stream<Map<String, dynamic>> get onStreamEnd => _streamEnd.stream;
  Stream<Map<String, dynamic>> get onError => _errorEvent.stream;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;

    final user = await _sessionManager.getCurrentUser();
    final token = user?.accessToken;
    if (token == null || token.isEmpty) {
      _stateController.add(ChatConnectionState.unauthenticated);
      return;
    }

    final baseUrl = (dotenv.env['API_BASE_URL'] ?? '').trim();
    if (baseUrl.isEmpty) {
      _stateController.add(ChatConnectionState.error);
      return;
    }

    _socket?.dispose();
    _socket = io.io(
      '$baseUrl/alerts',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .setReconnectionAttempts(8)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(8000)
          .build(),
    );

    _bindCoreEvents();
    _bindBusinessEvents();
    _socket!.connect();
    _stateController.add(ChatConnectionState.connecting);
  }

  void _bindCoreEvents() {
    final s = _socket!;
    s.onConnect((_) {
      dev.log('WS connected', name: 'ChatSocket');
      _stateController.add(ChatConnectionState.connected);
    });
    s.onDisconnect((_) {
      dev.log('WS disconnected', name: 'ChatSocket');
      _stateController.add(ChatConnectionState.disconnected);
    });
    s.onConnectError((err) {
      dev.log('WS connect_error: $err', name: 'ChatSocket');
      _stateController.add(ChatConnectionState.error);
    });
    s.onError((err) {
      dev.log('WS error: $err', name: 'ChatSocket');
    });
    s.onReconnectAttempt((_) {
      _stateController.add(ChatConnectionState.reconnecting);
    });
  }

  void _bindBusinessEvents() {
    final s = _socket!;
    s.on('alert_typing', (data) => _emit(_typing, data));
    s.on('alert_stream_start', (data) => _emit(_streamStart, data));
    s.on('alert_stream_chunk', (data) => _emit(_streamChunk, data));
    s.on('alert_stream_end', (data) => _emit(_streamEnd, data));
    s.on('error', (data) => _emit(_errorEvent, data));
    s.on('alert_error', (data) => _emit(_errorEvent, data));
  }

  void _emit(StreamController<Map<String, dynamic>> ctrl, dynamic data) {
    if (data is Map) {
      ctrl.add(Map<String, dynamic>.from(data));
    } else {
      ctrl.add(<String, dynamic>{'raw': data});
    }
  }

  void sendMessage(String message) {
    final s = _socket;
    if (s == null || !s.connected) {
      dev.log('sendMessage ignore : socket non connecte', name: 'ChatSocket');
      return;
    }
    s.emit('send_message', {'message': message});
  }

  Future<void> disconnect() async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _typing.close();
    await _streamStart.close();
    await _streamChunk.close();
    await _streamEnd.close();
    await _errorEvent.close();
    await _stateController.close();
  }
}
