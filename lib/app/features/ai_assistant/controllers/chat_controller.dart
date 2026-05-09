import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message.dart';
import '../models/chat_action.dart';
import '../services/chat_history_service.dart';
import '../services/chat_socket_service.dart';
import '../services/property_fetcher.dart';

const _kSessionId = 'ai_chat_session_id';
const _kLastActive = 'ai_chat_last_active';
const _kSessionTimeout = Duration(minutes: 30);

class ChatController extends ChangeNotifier {
  ChatController(
    this._socket, {
    PropertyFetcher? fetcher,
    ChatHistoryService? historyService,
  })  : _fetcher = fetcher,
        _historyService = historyService {
    _bind();
  }

  final ChatSocketService _socket;
  final PropertyFetcher? _fetcher;
  final ChatHistoryService? _historyService;

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool _typing = false;
  bool get typing => _typing;

  String _typingLabel = 'Immo AI réfléchit…';
  String get typingLabel => _typingLabel;
  Timer? _typingLabelTimer;

  ChatConnectionState _connection = ChatConnectionState.connecting;
  ChatConnectionState get connection => _connection;

  String? _currentSessionId;
  String? get currentSessionId => _currentSessionId;

  bool _loadingHistory = false;
  bool get loadingHistory => _loadingHistory;

  /// Hint contextuel pour le composer, basé sur le dernier message IA.
  String get composerHint {
    ChatMessage? last;
    for (var i = _messages.length - 1; i >= 0; i--) {
      final m = _messages[i];
      if (m.role == ChatRole.assistant && m.status == ChatStatus.complete) {
        last = m;
        break;
      }
    }
    if (last == null) return 'Demande quoi que ce soit sur l\'immo…';
    switch (last.responseType) {
      case AlertResponseType.alertClarification:
        return _hintForField(last.data?['askedField'] as String?);
      case AlertResponseType.alertConfirmation:
        return 'Confirmer, modifier ou annuler…';
      case AlertResponseType.error:
        return 'Reformule ta demande…';
      default:
        return 'Demande quoi que ce soit sur l\'immo…';
    }
  }

  String _hintForField(String? field) {
    switch (field?.toLowerCase()) {
      case 'location':
        return 'Ex : Cocody, Plateau, Yopougon…';
      case 'property_type':
        return 'Ex : Appartement, Villa, Studio…';
      case 'price_max':
        return 'Ex : 500 000 FCFA, 1 000 000 FCFA…';
      case 'rooms_min':
        return 'Ex : 2 pièces, 3 pièces…';
      case 'extras':
        return 'Ex : piscine, parking, meublé…';
      case 'surface_min':
        return 'Ex : 50 m², 80 m²…';
      default:
        return 'Réponds à la question de l\'IA…';
    }
  }

  StreamSubscription? _connSub;
  StreamSubscription? _typingSub;
  StreamSubscription? _startSub;
  StreamSubscription? _chunkSub;
  StreamSubscription? _endSub;
  StreamSubscription? _errSub;

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
    await _tryRestoreSession();
    await _socket.connect();
  }

  // ─── Session persistence ───────────────────────────────────────────────────

  Future<void> _tryRestoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString(_kSessionId);
    final lastActiveStr = prefs.getString(_kLastActive);
    if (sessionId == null || lastActiveStr == null) return;

    final lastActive = DateTime.tryParse(lastActiveStr);
    if (lastActive == null) return;

    if (DateTime.now().difference(lastActive) > _kSessionTimeout) {
      await prefs.remove(_kSessionId);
      await prefs.remove(_kLastActive);
      return;
    }

    await _loadSessionMessages(sessionId);
  }

  Future<void> _saveSession() async {
    final id = _currentSessionId;
    if (id == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSessionId, id);
    await prefs.setString(_kLastActive, DateTime.now().toIso8601String());
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSessionId);
    await prefs.remove(_kLastActive);
  }

  // ─── Load session (T5) ────────────────────────────────────────────────────

  Future<void> loadSession(String sessionId) async {
    await _loadSessionMessages(sessionId);
    await _saveSession();
  }

  Future<void> _loadSessionMessages(String sessionId) async {
    final service = _historyService;
    if (service == null) return;

    try {
      _loadingHistory = true;
      notifyListeners();

      final historyMessages = await service.getSessionMessages(sessionId);
      _currentSessionId = sessionId;
      _messages.clear();
      _messages.addAll(historyMessages.map((m) => m.toChatMessage()));
      notifyListeners();

      // Re-fetch property cards en arrière-plan
      for (var i = 0; i < _messages.length; i++) {
        final msg = _messages[i];
        if (msg.responseType == AlertResponseType.propertyAnswer &&
            msg.data != null &&
            msg.propertyCards == null) {
          final sources = msg.data!['sources'] as List? ?? [];
          if (sources.isNotEmpty && _fetcher != null) {
            final cards = await _fetcher.fetchSources(sources);
            if (cards.isNotEmpty) {
              _messages[i] = msg.copyWith(propertyCards: cards);
              notifyListeners();
            }
          }
        }
      }
    } catch (_) {
      _messages.clear();
      _currentSessionId = null;
    } finally {
      _loadingHistory = false;
      notifyListeners();
    }
  }

  // ─── Nouvelle conversation (T6) ───────────────────────────────────────────

  Future<void> startNewConversation() async {
    _messages.clear();
    _currentSessionId = null;
    _currentAssistantId = null;
    _stopTyping();
    notifyListeners();
    await _clearSession();
  }

  // ─── Envoi de message ─────────────────────────────────────────────────────

  void send(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;

    final userMsg = ChatMessage.user(text);
    _messages.add(userMsg);
    notifyListeners();

    if (!_socket.isConnected) {
      final idx = _messages.indexWhere((m) => m.id == userMsg.id);
      if (idx != -1) {
        _messages[idx] = userMsg.copyWith(status: ChatStatus.complete);
      }
      _messages.add(ChatMessage.assistantPlaceholder().copyWith(
        text: 'Connexion perdue. Vérifie ta connexion et réessaie.',
        status: ChatStatus.error,
        responseType: AlertResponseType.error,
      ));
      notifyListeners();
      return;
    }

    _socket.sendMessage(text, sessionId: _currentSessionId);

    final idx = _messages.indexWhere((m) => m.id == userMsg.id);
    if (idx != -1) {
      _messages[idx] = userMsg.copyWith(status: ChatStatus.complete);
      notifyListeners();
    }
  }

  // ─── Gestion du typing ────────────────────────────────────────────────────

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

  // ─── Événements WebSocket ─────────────────────────────────────────────────

  void _onStreamStart(Map<String, dynamic> payload) {
    _stopTyping();

    final sessionId = payload['sessionId'] as String?;
    if (sessionId != null) {
      _currentSessionId = sessionId;
      _saveSession();
    }

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
    var id = _currentAssistantId;
    _currentAssistantId = null;
    _stopTyping();

    // Mettre à jour sessionId si pas encore capturé
    final sessionId = payload['sessionId'] as String?;
    if (sessionId != null && _currentSessionId == null) {
      _currentSessionId = sessionId;
    }
    _saveSession();

    // §4 ContentModerationService : stream_end peut arriver sans stream_start.
    // On crée le placeholder à la volée pour ne pas perdre le message.
    if (id == null) {
      final typeStr = payload['type'] as String?;
      final placeholder = ChatMessage.assistantPlaceholder().copyWith(
        responseType: alertResponseTypeFromString(typeStr),
      );
      _messages.add(placeholder);
      id = placeholder.id;
    }

    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;

    final current = _messages[idx];
    final typeStr = payload['type'] as String?;
    final data = _extractData(payload);
    final finalText = _extractText(payload) ?? current.text;
    final responseType = typeStr != null
        ? alertResponseTypeFromString(typeStr)
        : current.responseType;

    _messages[idx] = current.copyWith(
      text: finalText,
      status: ChatStatus.complete,
      responseType: responseType,
      data: data,
      quickReplies: _extractQuickReplies(payload),
      actions: _extractActions(payload),
      meta: _extractMeta(payload),
    );
    notifyListeners();

    if (responseType == AlertResponseType.propertyAnswer) {
      _fetchAndUpdateProperties(id, data);
    }
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

  Future<void> _fetchAndUpdateProperties(
    String msgId,
    Map<String, dynamic>? data,
  ) async {
    final fetcher = _fetcher;
    if (fetcher == null) return;

    final sources = data?['sources'] as List? ?? [];
    if (sources.isEmpty) return;

    final cards = await fetcher.fetchSources(sources);
    if (cards.isEmpty) return;

    final idx = _messages.indexWhere((m) => m.id == msgId);
    if (idx == -1) return;

    _messages[idx] = _messages[idx].copyWith(propertyCards: cards);
    notifyListeners();
  }

  Map<String, dynamic>? _extractData(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    final reserved = {
      'type',
      'chunk',
      'message',
      'code',
      'sessionId',
      'quickReplies',
      'quick_replies',
      'actions',
      'meta',
    };
    final rest = <String, dynamic>{};
    for (final e in payload.entries) {
      if (!reserved.contains(e.key)) rest[e.key] = e.value;
    }
    return rest.isEmpty ? null : rest;
  }

  List<String> _extractQuickReplies(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is Map) {
      final nested = parseQuickReplies(
        data['quickReplies'] ?? data['quick_replies'],
      );
      if (nested.isNotEmpty) return nested;
    }

    return parseQuickReplies(
      payload['quickReplies'] ?? payload['quick_replies'],
    );
  }

  List<ChatActionModel> _extractActions(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is Map) {
      final nested = ChatActionModel.parseList(data['actions']);
      if (nested.isNotEmpty) return nested;
    }

    return ChatActionModel.parseList(payload['actions']);
  }

  Map<String, dynamic>? _extractMeta(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is Map && data['meta'] is Map) {
      return Map<String, dynamic>.from(data['meta'] as Map);
    }
    final meta = payload['meta'];
    if (meta is Map) {
      return Map<String, dynamic>.from(meta);
    }
    return null;
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
