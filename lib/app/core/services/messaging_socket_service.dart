import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:injectable/injectable.dart';

import '../../data/models/remote/messaging/message_model.dart';

/// Snapshot de présence renvoyé par l'ACK de `join_conversation`.
class PeerPresence {
  final String userId;
  final bool online;
  final DateTime? lastSeenAt;

  const PeerPresence({
    required this.userId,
    required this.online,
    this.lastSeenAt,
  });

  factory PeerPresence.fromJson(Map<String, dynamic> json) => PeerPresence(
        userId: json['userId']?.toString() ?? '',
        online: json['online'] == true,
        lastSeenAt: json['lastSeenAt'] != null
            ? DateTime.tryParse(json['lastSeenAt'].toString())
            : null,
      );
}

/// Événement `presence` (live update de ce que l'ACK de `join_conversation`
/// a donné comme état initial).
class PresenceEvent {
  final String conversationId;
  final String userId;
  final bool online;
  final DateTime? lastSeenAt;

  const PresenceEvent({
    required this.conversationId,
    required this.userId,
    required this.online,
    this.lastSeenAt,
  });

  factory PresenceEvent.fromJson(Map<String, dynamic> json) => PresenceEvent(
        conversationId: json['conversationId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        online: json['online'] == true,
        lastSeenAt: json['lastSeenAt'] != null
            ? DateTime.tryParse(json['lastSeenAt'].toString())
            : null,
      );
}

/// Événement `typing` — jamais reçu pour son propre `emit` (le serveur
/// exclut l'émetteur).
class TypingEvent {
  final String conversationId;
  final String userId;
  final bool isTyping;

  const TypingEvent({
    required this.conversationId,
    required this.userId,
    required this.isTyping,
  });

  factory TypingEvent.fromJson(Map<String, dynamic> json) => TypingEvent(
        conversationId: json['conversationId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        isTyping: json['isTyping'] == true,
      );
}

class ReadReceiptEvent {
  final String conversationId;
  final String userId;

  const ReadReceiptEvent({required this.conversationId, required this.userId});

  factory ReadReceiptEvent.fromJson(Map<String, dynamic> json) =>
      ReadReceiptEvent(
        conversationId: json['conversationId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
      );
}

class NewMessageEvent {
  final String conversationId;
  final MessageModel message;

  const NewMessageEvent({required this.conversationId, required this.message});

  factory NewMessageEvent.fromJson(Map<String, dynamic> json) =>
      NewMessageEvent(
        conversationId: json['conversationId']?.toString() ?? '',
        message:
            MessageModel.fromJson(Map<String, dynamic>.from(json['message'])),
      );
}

class MessagingNotificationEvent {
  final String conversationId;
  final String? messageId;
  final String? residenceId;

  const MessagingNotificationEvent({
    required this.conversationId,
    this.messageId,
    this.residenceId,
  });

  factory MessagingNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : <String, dynamic>{};
    return MessagingNotificationEvent(
      conversationId: data['conversationId']?.toString() ?? '',
      messageId: data['messageId']?.toString(),
      residenceId: data['residenceId']?.toString(),
    );
  }
}

/// Erreur d'ACK `send_message`. `code` n'est présent que pour un rejet de
/// modération (`CONTACT_INFO_DETECTED`) ; les autres échecs (conversation
/// bloquée, message vide, accès refusé...) n'ont que `message`.
class SendMessageAckError {
  final String? code;
  final String? moderationReason;
  final String message;

  const SendMessageAckError({
    this.code,
    this.moderationReason,
    required this.message,
  });

  bool get isModeration => code == 'CONTACT_INFO_DETECTED';

  factory SendMessageAckError.fromJson(Map<String, dynamic> json) =>
      SendMessageAckError(
        code: json['code']?.toString(),
        moderationReason: json['moderationReason']?.toString(),
        message: json['message']?.toString() ??
            'Le message n\'a pas pu être envoyé.',
      );
}

class SendMessageAckResult {
  final bool ok;
  final MessageModel? message;
  final SendMessageAckError? error;
  final String? clientTempId;

  const SendMessageAckResult({
    required this.ok,
    this.message,
    this.error,
    this.clientTempId,
  });

  factory SendMessageAckResult.fromJson(Map<String, dynamic> json) {
    final ok = json['ok'] == true;
    return SendMessageAckResult(
      ok: ok,
      message: ok && json['message'] is Map
          ? MessageModel.fromJson(Map<String, dynamic>.from(json['message']))
          : null,
      error: !ok && json['error'] is Map
          ? SendMessageAckError.fromJson(Map<String, dynamic>.from(json['error']))
          : null,
      clientTempId: json['clientTempId']?.toString(),
    );
  }
}

@lazySingleton
class MessagingSocketService {
  io.Socket? _socket;

  final _messageNewController = StreamController<NewMessageEvent>.broadcast();
  Stream<NewMessageEvent> get onMessageNew => _messageNewController.stream;

  final _typingController = StreamController<TypingEvent>.broadcast();
  Stream<TypingEvent> get onTyping => _typingController.stream;

  final _presenceController = StreamController<PresenceEvent>.broadcast();
  Stream<PresenceEvent> get onPresence => _presenceController.stream;

  final _readReceiptController = StreamController<ReadReceiptEvent>.broadcast();
  Stream<ReadReceiptEvent> get onReadReceipt => _readReceiptController.stream;

  final _notificationController =
      StreamController<MessagingNotificationEvent>.broadcast();
  Stream<MessagingNotificationEvent> get onNotificationNew =>
      _notificationController.stream;

  /// Émis à chaque (re)connexion du socket, pas seulement la première — une
  /// room `conversation:{id}` est attachée au socket.id, donc une reconnexion
  /// (perte réseau, retour d'arrière-plan) en crée un nouveau et sort
  /// silencieusement le client de la room sans jamais la lui redonner tant
  /// que personne ne rémet `join_conversation`. `ConversationThreadCubit`
  /// écoute ce flux pour rejoindre à nouveau la conversation ouverte.
  final _connectController = StreamController<void>.broadcast();
  Stream<void> get onConnected => _connectController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String? accessToken) {
    if (accessToken == null || accessToken.isEmpty) return;
    if (_socket != null && _socket!.connected) return;

    final baseUrl = (dotenv.env['API_BASE_URL'] ?? '').trim();
    if (baseUrl.isEmpty) return;

    _socket?.dispose();
    _socket = io.io(
      '$baseUrl/messages',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .disableAutoConnect()
          .setReconnectionAttempts(8)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(8000)
          .build(),
    );

    _socket!.onConnect((_) {
      dev.log('connecté', name: 'MessagingSocket');
      _connectController.add(null);
    });
    _socket!.onDisconnect((reason) {
      dev.log('déconnecté: $reason', name: 'MessagingSocket');
    });
    _socket!.onConnectError((err) {
      dev.log('erreur connexion: $err', name: 'MessagingSocket');
    });

    _socket!.on('message_new', (data) {
      if (data is Map<String, dynamic>) {
        try {
          _messageNewController.add(NewMessageEvent.fromJson(data));
        } catch (e) {
          dev.log('Erreur parsing message_new: $e', name: 'MessagingSocket');
        }
      }
    });

    _socket!.on('typing', (data) {
      if (data is Map<String, dynamic>) {
        try {
          _typingController.add(TypingEvent.fromJson(data));
        } catch (e) {
          dev.log('Erreur parsing typing: $e', name: 'MessagingSocket');
        }
      }
    });

    _socket!.on('presence', (data) {
      if (data is Map<String, dynamic>) {
        try {
          _presenceController.add(PresenceEvent.fromJson(data));
        } catch (e) {
          dev.log('Erreur parsing presence: $e', name: 'MessagingSocket');
        }
      }
    });

    _socket!.on('read_receipt', (data) {
      if (data is Map<String, dynamic>) {
        try {
          _readReceiptController.add(ReadReceiptEvent.fromJson(data));
        } catch (e) {
          dev.log('Erreur parsing read_receipt: $e', name: 'MessagingSocket');
        }
      }
    });

    _socket!.on('notification_new', (data) {
      if (data is Map<String, dynamic>) {
        try {
          _notificationController
              .add(MessagingNotificationEvent.fromJson(data));
        } catch (e) {
          dev.log('Erreur parsing notification_new: $e',
              name: 'MessagingSocket');
        }
      }
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  /// Rejoint la room du fil ; l'ACK donne le snapshot initial de présence du
  /// pro. À appeler au montage de l'écran de fil, avant toute écoute
  /// `presence` (qui ne donne que les mises à jour live ensuite).
  Future<PeerPresence?> joinConversation(String conversationId) async {
    final socket = _socket;
    if (socket == null || !socket.connected) return null;
    try {
      final ack = await socket
          .emitWithAckAsync('join_conversation', {'conversationId': conversationId})
          .timeout(const Duration(seconds: 8));
      if (ack is Map && ack['ok'] == true && ack['peer'] is Map) {
        return PeerPresence.fromJson(Map<String, dynamic>.from(ack['peer']));
      }
      return null;
    } catch (e) {
      dev.log('join_conversation échoué: $e', name: 'MessagingSocket');
      return null;
    }
  }

  /// Pas requis par le serveur (aucune règle ne l'exige), mais évite de
  /// rester membre de la room au-delà de la durée d'affichage réelle du
  /// fil — hygiène uniquement, pas une correction de bug.
  void leaveConversation(String conversationId) {
    final socket = _socket;
    if (socket == null || !socket.connected) return;
    socket.emit('leave_conversation', {'conversationId': conversationId});
  }

  void emitTyping(String conversationId, bool isTyping) {
    final socket = _socket;
    if (socket == null || !socket.connected) return;
    socket.emit('typing', {'conversationId': conversationId, 'isTyping': isTyping});
  }

  /// Envoi optimiste via socket. Lève une [TimeoutException] si aucun ACK
  /// n'arrive — l'appelant doit alors basculer sur le fallback HTTP.
  Future<SendMessageAckResult> sendMessage({
    required String conversationId,
    required String content,
    required String clientTempId,
  }) async {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      throw StateError('Socket non connecté');
    }
    final ack = await socket.emitWithAckAsync('send_message', {
      'conversationId': conversationId,
      'content': content,
      'clientTempId': clientTempId,
    }).timeout(const Duration(seconds: 8));
    return SendMessageAckResult.fromJson(Map<String, dynamic>.from(ack as Map));
  }
}
