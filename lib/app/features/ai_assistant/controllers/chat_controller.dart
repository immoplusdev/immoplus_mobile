import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../services/chat_socket_service.dart';

class ChatController extends ChangeNotifier {
  ChatController(this._socket) {
    _bind();
  }

  final ChatSocketService _socket;

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool _typing = false;
  bool get typing => _typing;

  String _typingLabel = 'Immo AI réfléchit…';
  String get typingLabel => _typingLabel;
  Timer? _typingLabelTimer;

  ChatConnectionState _connection = ChatConnectionState.connecting;
  ChatConnectionState get connection => _connection;

  StreamSubscription? _connSub;
  StreamSubscription? _typingSub;
  StreamSubscription? _startSub;
  StreamSubscription? _chunkSub;
  StreamSubscription? _endSub;
  StreamSubscription? _errSub;

  // ID de la bulle IA en cours de stream (1 à la fois).
  String? _currentAssistantId;

  void _bind() {
    _connSub = _socket.connectionState.listen((s) {
      _connection = s;
      notifyListeners();
    });
    _typingSub = _socket.onTyping.listen((_) => _startTyping());
    _startSub = _socket.onStreamStart.listen(_onStreamStart);
    _chunkSub = _socket.onStreamChunk.listen(_onStreamChunk);
    _endSub = _socket.onStreamEnd.listen(_onStreamEnd);
    _errSub = _socket.onError.listen(_onErrorEvent);
  }

  Future<void> init() async {
    await _socket.connect();
  }

  void send(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;

    final userMsg = ChatMessage.user(text);
    _messages.add(userMsg);
    notifyListeners();

    _socket.sendMessage(text);

    // Optimistic : marquer le message user comme envoyé juste après émission.
    final idx = _messages.indexWhere((m) => m.id == userMsg.id);
    if (idx != -1) {
      _messages[idx] = userMsg.copyWith(status: ChatStatus.complete);
      notifyListeners();
    }
  }

  void _startTyping() {
    _typing = true;
    _typingLabel = 'Immo AI réfléchit…';
    notifyListeners();

    _typingLabelTimer?.cancel();
    _typingLabelTimer = Timer(const Duration(seconds: 2), () {
      _typingLabel = 'Je cherche dans les biens…';
      notifyListeners();
      _typingLabelTimer = Timer(const Duration(seconds: 2), () {
        _typingLabel = 'Je compare les résultats…';
        notifyListeners();
      });
    });
  }

  void _stopTyping() {
    _typing = false;
    _typingLabelTimer?.cancel();
    _typingLabelTimer = null;
    notifyListeners();
  }

  void _onStreamStart(Map<String, dynamic> payload) {
    _stopTyping();
    final typeStr = payload['type'] as String?;
    final placeholder = ChatMessage.assistantPlaceholder().copyWith(
      responseType: alertResponseTypeFromString(typeStr),
    );
    _messages.add(placeholder);
    _currentAssistantId = placeholder.id;
    notifyListeners();
  }

  void _onStreamChunk(Map<String, dynamic> payload) {
    final id = _currentAssistantId;
    if (id == null) return;
    final chunk = payload['chunk'];
    if (chunk is! String || chunk.isEmpty) return;

    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    final current = _messages[idx];
    _messages[idx] = current.copyWith(text: current.text + chunk);
    notifyListeners();
  }

  void _onStreamEnd(Map<String, dynamic> payload) {
    final id = _currentAssistantId;
    _currentAssistantId = null;
    _stopTyping();

    if (id == null) return;
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;

    final current = _messages[idx];
    final typeStr = payload['type'] as String?;
    final data = _extractData(payload);
    final finalText = _extractText(payload) ?? current.text;

    _messages[idx] = current.copyWith(
      text: finalText,
      status: ChatStatus.complete,
      responseType: typeStr != null
          ? alertResponseTypeFromString(typeStr)
          : current.responseType,
      data: data,
    );
    notifyListeners();
  }

  void _onErrorEvent(Map<String, dynamic> payload) {
    _stopTyping();
    final msg = payload['message'] as String? ??
        "J'ai pas bien saisi ta demande 🤔 Tu peux reformuler ?";
    final code = payload['code'] as String?;

    final id = _currentAssistantId;
    _currentAssistantId = null;

    if (id != null) {
      final idx = _messages.indexWhere((m) => m.id == id);
      if (idx != -1) {
        _messages[idx] = _messages[idx].copyWith(
          text: msg,
          status: ChatStatus.error,
          responseType: AlertResponseType.error,
          errorCode: code,
        );
        notifyListeners();
        return;
      }
    }

    final errMsg = ChatMessage.assistantPlaceholder().copyWith(
      text: msg,
      status: ChatStatus.error,
      responseType: AlertResponseType.error,
      errorCode: code,
    );
    _messages.add(errMsg);
    notifyListeners();
  }

  Map<String, dynamic>? _extractData(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    // Le backend peut aussi renvoyer le payload à plat
    final reserved = {'type', 'chunk', 'message', 'code'};
    final rest = <String, dynamic>{};
    for (final e in payload.entries) {
      if (!reserved.contains(e.key)) rest[e.key] = e.value;
    }
    return rest.isEmpty ? null : rest;
  }

  String? _extractText(Map<String, dynamic> payload) {
    final direct = payload['message'];
    if (direct is String && direct.isNotEmpty) return direct;
    final data = payload['data'];
    if (data is Map) {
      final m = data['message'] ?? data['answer'];
      if (m is String && m.isNotEmpty) return m;
    }
    final answer = payload['answer'];
    if (answer is String && answer.isNotEmpty) return answer;
    return null;
  }

  @override
  void dispose() {
    _connSub?.cancel();
    _typingSub?.cancel();
    _startSub?.cancel();
    _chunkSub?.cancel();
    _endSub?.cancel();
    _errSub?.cancel();
    _typingLabelTimer?.cancel();
    _socket.dispose();
    super.dispose();
  }
}
