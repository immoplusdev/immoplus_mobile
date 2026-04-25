import 'dart:math' as math;

enum ChatRole { user, assistant }

enum ChatStatus { sending, streaming, complete, error, stopped }

enum AlertResponseType {
  alertCreated,
  alertUpdated,
  alertDeleted,
  alertClarification,
  showResults,
  propertyAnswer,
  generalAdvice,
  error,
  unknown,
}

AlertResponseType alertResponseTypeFromString(String? raw) {
  switch (raw) {
    case 'alert_created':
      return AlertResponseType.alertCreated;
    case 'alert_updated':
      return AlertResponseType.alertUpdated;
    case 'alert_deleted':
      return AlertResponseType.alertDeleted;
    case 'alert_clarification':
      return AlertResponseType.alertClarification;
    case 'show_results':
      return AlertResponseType.showResults;
    case 'property_answer':
      return AlertResponseType.propertyAnswer;
    case 'general_advice':
      return AlertResponseType.generalAdvice;
    case 'error':
      return AlertResponseType.error;
    default:
      return AlertResponseType.unknown;
  }
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.status,
    required this.createdAt,
    this.responseType,
    this.data,
    this.errorCode,
  });

  final String id;
  final ChatRole role;
  final String text;
  final ChatStatus status;
  final DateTime createdAt;
  final AlertResponseType? responseType;
  final Map<String, dynamic>? data;
  final String? errorCode;

  ChatMessage copyWith({
    String? text,
    ChatStatus? status,
    AlertResponseType? responseType,
    Map<String, dynamic>? data,
    String? errorCode,
  }) {
    return ChatMessage(
      id: id,
      role: role,
      text: text ?? this.text,
      status: status ?? this.status,
      createdAt: createdAt,
      responseType: responseType ?? this.responseType,
      data: data ?? this.data,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  static ChatMessage user(String text) {
    return ChatMessage(
      id: _newId(),
      role: ChatRole.user,
      text: text,
      status: ChatStatus.sending,
      createdAt: DateTime.now(),
    );
  }

  static ChatMessage assistantPlaceholder() {
    return ChatMessage(
      id: _newId(),
      role: ChatRole.assistant,
      text: '',
      status: ChatStatus.streaming,
      createdAt: DateTime.now(),
    );
  }
}

final math.Random _rng = math.Random();
String _newId() {
  final ts = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final rand = _rng.nextInt(1 << 32).toRadixString(36);
  return '$ts-$rand';
}
