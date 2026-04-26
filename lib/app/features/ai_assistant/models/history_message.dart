import 'chat_message.dart';

class HistoryMessage {
  const HistoryMessage({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.type,
    this.sources,
  });

  final String id;
  final String userId;
  final String sessionId;
  final ChatRole role;
  final String content;
  final DateTime createdAt;
  final AlertResponseType? type;

  /// `{ "answer": "...", "sources": [...] }` — null pour les messages user.
  final Map<String, dynamic>? sources;

  factory HistoryMessage.fromJson(Map<String, dynamic> json) {
    final roleRaw = (json['role'] as String?) ?? 'user';
    final createdAtRaw = json['createdAt'] as String?;
    final rawSources = json['sources'];

    return HistoryMessage(
      id: (json['id'] as String?) ?? '',
      userId: (json['userId'] as String?) ?? '',
      sessionId: (json['sessionId'] as String?) ?? '',
      role: roleRaw == 'assistant' ? ChatRole.assistant : ChatRole.user,
      content: (json['content'] as String?) ?? '',
      createdAt: createdAtRaw != null
          ? DateTime.tryParse(createdAtRaw) ?? DateTime.now()
          : DateTime.now(),
      type: alertResponseTypeFromString(json['type'] as String?),
      sources: rawSources != null && rawSources is Map
          ? Map<String, dynamic>.from(rawSources)
          : null,
    );
  }

  /// Convertit en ChatMessage affichable dans le thread.
  /// Les propertyCards sont null ici — le controller les charge via PropertyFetcher.
  ChatMessage toChatMessage() {
    return ChatMessage(
      id: id,
      role: role,
      text: content,
      status: ChatStatus.complete,
      createdAt: createdAt,
      responseType: type,
      data: sources,
    );
  }
}
