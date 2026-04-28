import 'chat_message.dart';

class ConversationSummary {
  const ConversationSummary({
    required this.sessionId,
    required this.title,
    required this.messageCount,
    required this.lastMessageAt,
    this.type,
  });

  final String sessionId;
  final String title;
  final int messageCount;
  final DateTime lastMessageAt;
  final AlertResponseType? type;

  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    final lastMessageAtRaw = json['lastMessageAt'] as String?;
    return ConversationSummary(
      sessionId: (json['sessionId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      messageCount: (json['messageCount'] as int?) ?? 0,
      lastMessageAt: lastMessageAtRaw != null
          ? DateTime.tryParse(lastMessageAtRaw) ?? DateTime.now()
          : DateTime.now(),
      type: alertResponseTypeFromString(json['type'] as String?),
    );
  }
}
