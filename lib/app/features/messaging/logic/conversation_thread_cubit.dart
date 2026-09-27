import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/messaging_socket_service.dart';
import '../../../data/models/remote/messaging/message_model.dart';
import '../../../data/repositories/messaging_repository.dart';
import 'conversation_thread_state.dart';

@injectable
class ConversationThreadCubit extends Cubit<ConversationThreadState> {
  final MessagingRepository _repository;
  final MessagingSocketService _socketService;

  String? _conversationId;
  StreamSubscription? _messageNewSub;
  StreamSubscription? _typingSub;
  StreamSubscription? _presenceSub;
  StreamSubscription? _readReceiptSub;
  StreamSubscription? _socketConnectSub;
  Timer? _typingSafetyTimer;
  Timer? _typingStopDebounce;
  bool _isTypingEmitted = false;

  ConversationThreadCubit(this._repository, this._socketService)
      : super(const ConversationThreadState.loading());

  /// Recharge le fil déjà ciblé — utilisé par le bouton "Réessayer" de
  /// l'état d'erreur, pour ne pas forcer un retour en arrière sur un échec
  /// réseau transitoire.
  Future<void> retry() async {
    final id = _conversationId;
    if (id != null) await load(id);
  }

  Future<void> load(String conversationId) async {
    _conversationId = conversationId;
    emit(const ConversationThreadState.loading());
    try {
      final conversation = await _repository.getConversation(conversationId);
      final rawMessages = await _repository.getMessages(conversationId, limit: 30);
      // L'API renvoie du plus récent au plus ancien : on inverse pour
      // l'affichage chronologique (spec §5 : "le frontend inverse la liste").
      final chronological = rawMessages.reversed.toList();

      emit(ConversationThreadState.loaded(
        conversation: conversation,
        messages: chronological,
      ));

      _startListening(conversationId);
      unawaited(_joinAndCapturePresence(conversationId));

      if (chronological.isNotEmpty) {
        unawaited(_markRead());
      }
    } catch (e) {
      emit(ConversationThreadState.error(
          e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _joinAndCapturePresence(String conversationId) async {
    final peer = await _socketService.joinConversation(conversationId);
    if (peer == null || isClosed) return;
    final current = state;
    if (current is ConversationThreadLoaded) {
      emit(current.copyWith(peerPresence: peer));
    }
  }

  void _startListening(String conversationId) {
    // Rejoint la room à chaque reconnexion (pas seulement au premier
    // chargement) : une room est attachée au socket.id, donc une
    // reconnexion silencieuse (réseau, retour d'arrière-plan) en sort le
    // client sans lui redonner tant qu'on ne renvoie pas `join_conversation`.
    _socketConnectSub?.cancel();
    _socketConnectSub = _socketService.onConnected.listen((_) {
      unawaited(_joinAndCapturePresence(conversationId));
    });

    _messageNewSub?.cancel();
    _messageNewSub = _socketService.onMessageNew.listen((event) {
      if (event.conversationId != conversationId) return;
      final current = state;
      if (current is! ConversationThreadLoaded) return;

      // Un message envoyé par le client lui-même est déjà géré localement
      // par l'aller-retour optimiste + ACK de sendText()/_attemptSend() : le
      // broadcast `message_new` de la room (qui inclut aussi l'émetteur) ne
      // doit jamais le réinsérer, sous peine de doublon dans la liste.
      if (event.message.isFromClient) return;

      final alreadyPresent =
          current.messages.any((m) => m.id == event.message.id);
      if (alreadyPresent) return;

      emit(current.copyWith(messages: [...current.messages, event.message]));
      unawaited(_markRead());
    });

    _typingSub?.cancel();
    _typingSub = _socketService.onTyping.listen((event) {
      if (event.conversationId != conversationId) return;
      final current = state;
      if (current is! ConversationThreadLoaded) return;
      emit(current.copyWith(peerTyping: event.isTyping));
      _typingSafetyTimer?.cancel();
      if (event.isTyping) {
        // Filet de sécurité (spec §5.6) si jamais aucun `isTyping:false` ni
        // message réel n'arrive.
        _typingSafetyTimer = Timer(const Duration(seconds: 10), () {
          final s = state;
          if (s is ConversationThreadLoaded) {
            emit(s.copyWith(peerTyping: false));
          }
        });
      }
    });

    _presenceSub?.cancel();
    _presenceSub = _socketService.onPresence.listen((event) {
      if (event.conversationId != conversationId) return;
      final current = state;
      if (current is! ConversationThreadLoaded) return;
      emit(current.copyWith(
        peerPresence: PeerPresence(
          userId: event.userId,
          online: event.online,
          lastSeenAt: event.lastSeenAt,
        ),
      ));
    });

    _readReceiptSub?.cancel();
    _readReceiptSub = _socketService.onReadReceipt.listen((event) {
      if (event.conversationId != conversationId) return;
      final current = state;
      if (current is! ConversationThreadLoaded) return;
      emit(current.copyWith(peerLastReadAt: DateTime.now()));
    });
  }

  Future<void> _markRead() async {
    final id = _conversationId;
    if (id == null) return;
    try {
      await _repository.markRead(id);
    } catch (_) {
      // Best-effort : ne bloque jamais l'affichage du fil.
    }
  }

  /// À appeler à chaque frappe dans le composer — débounce l'émission
  /// `typing` (spec §5.6 : `true` dès la première frappe, `false` après
  /// ~3s d'inactivité ou à l'envoi).
  void onComposerTextChanged() {
    final id = _conversationId;
    if (id == null) return;
    if (!_isTypingEmitted) {
      _isTypingEmitted = true;
      _socketService.emitTyping(id, true);
    }
    _typingStopDebounce?.cancel();
    _typingStopDebounce = Timer(const Duration(seconds: 3), () {
      _isTypingEmitted = false;
      _socketService.emitTyping(id, false);
    });
  }

  void _stopTypingImmediately() {
    final id = _conversationId;
    if (id == null) return;
    _typingStopDebounce?.cancel();
    if (_isTypingEmitted) {
      _isTypingEmitted = false;
      _socketService.emitTyping(id, false);
    }
  }

  Future<void> sendText(String content) async {
    final id = _conversationId;
    final current = state;
    if (id == null || current is! ConversationThreadLoaded) return;
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    _stopTypingImmediately();

    final clientTempId = const Uuid().v4();
    final optimistic = MessageModel(
      id: clientTempId,
      conversationId: id,
      senderRole: 'client',
      content: trimmed,
      createdAt: DateTime.now(),
      clientTempId: clientTempId,
      deliveryState: MessageDeliveryState.sending,
    );
    emit(current.copyWith(messages: [...current.messages, optimistic]));

    await _attemptSend(clientTempId, trimmed);
  }

  Future<void> retryMessage(String clientTempId) async {
    final current = state;
    if (current is! ConversationThreadLoaded) return;
    final target = current.messages.firstWhere(
      (m) => m.clientTempId == clientTempId,
      orElse: () => current.messages.first,
    );
    if (target.clientTempId != clientTempId) return;
    _replaceMessage(
      clientTempId,
      target.copyWith(deliveryState: MessageDeliveryState.sending),
    );
    await _attemptSend(clientTempId, target.content);
  }

  void deleteFailedMessage(String clientTempId) {
    final current = state;
    if (current is! ConversationThreadLoaded) return;
    emit(current.copyWith(
      messages:
          current.messages.where((m) => m.clientTempId != clientTempId).toList(),
    ));
  }

  Future<void> _attemptSend(String clientTempId, String content) async {
    final id = _conversationId;
    if (id == null) return;

    try {
      if (_socketService.isConnected) {
        final ack = await _socketService.sendMessage(
          conversationId: id,
          content: content,
          clientTempId: clientTempId,
        );
        if (ack.ok && ack.message != null) {
          _replaceMessage(clientTempId, ack.message!);
          return;
        }
        if (ack.error?.isModeration == true) {
          _rejectByModeration(clientTempId, ack.error!.message);
          return;
        }
        _markFailed(clientTempId);
        return;
      }
      await _sendViaHttpFallback(clientTempId, content);
    } catch (_) {
      // Timeout/StateError du socket (déconnecté ou ACK jamais reçu) :
      // on retente en HTTP avant d'abandonner (spec §8 : fallback HTTP
      // pendant une coupure socket).
      await _sendViaHttpFallback(clientTempId, content);
    }
  }

  Future<void> _sendViaHttpFallback(String clientTempId, String content) async {
    final id = _conversationId;
    if (id == null) return;
    try {
      final message = await _repository.sendMessageHttp(
        id,
        content: content,
        clientTempId: clientTempId,
      );
      _replaceMessage(clientTempId, message);
    } on DioException catch (dioError) {
      final data = dioError.response?.data;
      if (data is Map && data['code'] == 'CONTACT_INFO_DETECTED') {
        _rejectByModeration(
          clientTempId,
          data['message']?.toString() ??
              'Ce message ne peut pas être envoyé : les numéros de téléphone, '
                  'e-mails, liens et réseaux sociaux ne sont pas autorisés dans '
                  'la conversation.',
        );
      } else {
        _markFailed(clientTempId);
      }
    } catch (_) {
      _markFailed(clientTempId);
    }
  }

  void _replaceMessage(String clientTempId, MessageModel serverMessage) {
    final current = state;
    if (current is! ConversationThreadLoaded) return;
    final updated = current.messages
        .map((m) => m.clientTempId == clientTempId
            ? serverMessage.copyWith(deliveryState: MessageDeliveryState.sent)
            : m)
        .toList();
    emit(current.copyWith(messages: updated));
  }

  void _markFailed(String clientTempId) {
    final current = state;
    if (current is! ConversationThreadLoaded) return;
    final updated = current.messages
        .map((m) => m.clientTempId == clientTempId
            ? m.copyWith(deliveryState: MessageDeliveryState.failed)
            : m)
        .toList();
    emit(current.copyWith(messages: updated));
  }

  /// Rejet de modération (spec §5.7) : le message ne doit jamais apparaître
  /// comme envoyé — on retire la bulle optimiste et on affiche le bandeau.
  void _rejectByModeration(String clientTempId, String bannerMessage) {
    final current = state;
    if (current is! ConversationThreadLoaded) return;
    emit(current.copyWith(
      messages:
          current.messages.where((m) => m.clientTempId != clientTempId).toList(),
      moderationBannerMessage: bannerMessage,
    ));
  }

  /// À appeler quand l'utilisateur modifie à nouveau le texte après un
  /// rejet de modération (spec §5.7 : le bandeau disparaît dès la
  /// modification).
  void dismissModerationBanner() {
    final current = state;
    if (current is ConversationThreadLoaded &&
        current.moderationBannerMessage != null) {
      emit(current.copyWith(moderationBannerMessage: null));
    }
  }

  Future<bool> block() async {
    final id = _conversationId;
    final current = state;
    if (id == null || current is! ConversationThreadLoaded) return false;
    try {
      await _repository.blockConversation(id);
      emit(current.copyWith(
        conversation: current.conversation.copyWith(status: 'blocked'),
      ));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> report({required String reason, String? details}) async {
    final id = _conversationId;
    if (id == null) return false;
    try {
      await _repository.reportConversation(id, reason: reason, details: details);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() {
    _messageNewSub?.cancel();
    _typingSub?.cancel();
    _presenceSub?.cancel();
    _readReceiptSub?.cancel();
    _socketConnectSub?.cancel();
    _typingSafetyTimer?.cancel();
    _typingStopDebounce?.cancel();
    _stopTypingImmediately();
    final id = _conversationId;
    if (id != null) _socketService.leaveConversation(id);
    return super.close();
  }
}
