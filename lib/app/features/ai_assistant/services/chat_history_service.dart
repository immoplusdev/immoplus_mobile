import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/conversation_summary.dart';
import '../models/history_message.dart';

@lazySingleton
class ChatHistoryService {
  const ChatHistoryService(this._dio);

  final Dio _dio;

  Future<List<ConversationSummary>> getConversations({
    int limit = 20,
    int offset = 0,
  }) async {
    final resp = await _dio.get<dynamic>(
      '/chat/history',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final data = resp.data;
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => ConversationSummary.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<HistoryMessage>> getSessionMessages(String sessionId) async {
    final resp = await _dio.get<dynamic>('/chat/history/$sessionId');
    final data = resp.data;
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => HistoryMessage.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> deleteSession(String sessionId) async {
    await _dio.delete<void>('/chat/history/$sessionId');
  }

  Future<void> deleteAllHistory() async {
    await _dio.delete<void>('/chat/history');
  }
}
