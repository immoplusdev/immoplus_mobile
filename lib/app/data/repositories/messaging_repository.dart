import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/remote/messaging/client_guidance_model.dart';
import '../models/remote/messaging/conversation_model.dart';
import '../models/remote/messaging/conversation_type_count.dart';
import '../models/remote/messaging/create_conversation_response.dart';
import '../models/remote/messaging/message_model.dart';
import '../providers/messaging_provider.dart';

@injectable
class MessagingRepository {
  static const _guidanceCacheKey = 'messaging_client_guidance_v1';
  final Dio dioClient;
  MessagingRepository(this.dioClient);

  /// `POST /conversations` — get-or-create le fil pour cette résidence et y
  /// poste le premier message.
  Future<CreateConversationResponse> createOrResumeConversation({
    required String residenceId,
    required String message,
  }) async {
    try {
      final response =
          await MessagingProvider(dioClient).createOrResumeConversation({
        'residenceId': residenceId,
        'message': message,
      });
      return response;
    } on DioException catch (dioError) {
      // Rethrown (pas wrappé) : l'appelant a besoin du statusCode/body bruts
      // pour distinguer 403 / CONTACT_INFO_DETECTED (cf. spec composer §3).
      log('DioError: ${dioError.message}');
      rethrow;
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to create conversation: $error');
    }
  }

  /// `POST /conversations/visite` — réservé au demandeur de la visite.
  Future<CreateConversationResponse> createVisiteConversation({
    required String demandeVisiteId,
    required String message,
  }) async {
    try {
      final response =
          await MessagingProvider(dioClient).createVisiteConversation({
        'demandeVisiteId': demandeVisiteId,
        'message': message,
      });
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      rethrow;
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to create visite conversation: $error');
    }
  }

  /// `POST /conversations/support` — get-or-create automatique.
  Future<CreateConversationResponse> createSupportConversation({
    required String message,
  }) async {
    try {
      final response = await MessagingProvider(dioClient)
          .createSupportConversation({'message': message});
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      rethrow;
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to create support conversation: $error');
    }
  }

  /// Ouvre le fil support guidé sans inventer de premier message côté client.
  /// La réponse peut être enveloppée (`conversation`) ou être directement le
  /// fil selon la version du backend ; seul l'identifiant est nécessaire ici.
  Future<String> openSupportConversation() async {
    try {
      final response = await dioClient.post<dynamic>(
        '/conversations/support/open',
      );
      final raw = response.data;
      if (raw is! Map) {
        throw const FormatException('Réponse support invalide');
      }
      final envelope = Map<String, dynamic>.from(raw);
      final data = envelope['data'] is Map
          ? Map<String, dynamic>.from(envelope['data'] as Map)
          : envelope;
      final conversation = data['conversation'];
      final id = conversation is Map
          ? conversation['id']?.toString()
          : data['id']?.toString();
      if (id == null || id.isEmpty) {
        throw const FormatException('Identifiant du fil support absent');
      }
      return id;
    } on DioException catch (dioError) {
      log('DioError opening support: ${dioError.message}');
      rethrow;
    }
  }

  /// `POST /conversations/relais` — réservé à l'occupant et au demandeur
  /// avec un intérêt `in_progress` sur ce relais.
  Future<CreateConversationResponse> createRelaisConversation({
    required String relaisId,
    required String message,
  }) async {
    try {
      final response =
          await MessagingProvider(dioClient).createRelaisConversation({
        'relaisId': relaisId,
        'message': message,
      });
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      rethrow;
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to create relais conversation: $error');
    }
  }

  Future<List<ConversationModel>> getConversations({
    ConversationType? type,
  }) async {
    try {
      final response = await MessagingProvider(dioClient)
          .getConversations(type: type?.value);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load conversations: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load conversations: $error');
    }
  }

  /// `GET /conversations/counts` — un calcul serveur par type, pas de ligne
  /// "toutes" (à sommer côté front pour le badge de l'onglet Messages).
  Future<List<ConversationTypeCount>> getConversationCounts() async {
    try {
      final response =
          await MessagingProvider(dioClient).getConversationCounts();
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to load conversation counts: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load conversation counts: $error');
    }
  }

  Future<ConversationModel> getConversation(String conversationId) async {
    try {
      final response =
          await MessagingProvider(dioClient).getConversation(conversationId);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load conversation: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load conversation: $error');
    }
  }

  Future<List<MessageModel>> getMessages(
    String conversationId, {
    int limit = 30,
    String? before,
  }) async {
    try {
      if (before == null || before.isEmpty) {
        return MessagingProvider(dioClient).getMessages(
          conversationId,
          limit: limit,
        );
      }
      final response = await dioClient.get<dynamic>(
        '/conversations/$conversationId/messages',
        queryParameters: {'limit': limit, 'before': before},
      );
      final raw = response.data;
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((item) => MessageModel.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(growable: false);
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load messages: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load messages: $error');
    }
  }

  /// Fallback HTTP d'envoi (utilisé quand le socket est indisponible).
  Future<MessageModel> sendMessageHttp(
    String conversationId, {
    String? content,
    required String clientTempId,
    String? type,
    Map<String, dynamic>? payload,
    String? replyToId,
  }) async {
    try {
      final response = await MessagingProvider(dioClient).sendMessage(
        conversationId,
        {
          if (content != null) 'content': content,
          'clientTempId': clientTempId,
          if (type != null) 'type': type,
          if (payload != null) 'payload': payload,
          if (replyToId != null) 'replyToId': replyToId,
        },
      );
      return response;
    } on DioException catch (dioError) {
      // Idem createOrResumeConversation : on garde le DioException brut pour
      // que l'appelant distingue le blocage de modération des autres échecs.
      log('DioError: ${dioError.message}');
      rethrow;
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to send message: $error');
    }
  }

  /// `PATCH /conversations/:id/read` → `{ id, unreadCount }`.
  Future<int> markRead(String conversationId) async {
    try {
      final response =
          await MessagingProvider(dioClient).markRead(conversationId);
      final data = response.response.data;
      if (data is Map) {
        return (data['unreadCount'] as num?)?.toInt() ?? 0;
      }
      return 0;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to mark conversation as read: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to mark conversation as read: $error');
    }
  }

  Future<void> blockConversation(String conversationId) async {
    try {
      await MessagingProvider(dioClient).blockConversation(conversationId);
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to block conversation: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to block conversation: $error');
    }
  }

  Future<void> reportConversation(
    String conversationId, {
    required String reason,
    String? details,
  }) async {
    try {
      await MessagingProvider(dioClient).reportConversation(
        conversationId,
        {
          'reason': reason,
          if (details != null && details.isNotEmpty) 'details': details,
        },
      );
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to report conversation: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to report conversation: $error');
    }
  }

  Future<void> reportMessage(
    String conversationId,
    String messageId, {
    required String reason,
    String? details,
  }) async {
    await dioClient.post<dynamic>(
      '/conversations/$conversationId/messages/$messageId/report',
      data: {
        'reason': reason,
        if (details != null && details.isNotEmpty) 'details': details,
      },
    );
  }

  Future<ClientGuidanceResponse?> loadCachedClientGuidance() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(_guidanceCacheKey);
      if (raw == null || raw.isEmpty) return null;
      final json = jsonDecode(raw);
      return json is Map
          ? ClientGuidanceResponse.fromJson(Map<String, dynamic>.from(json))
          : null;
    } catch (_) {
      return null;
    }
  }

  Future<ClientGuidanceResponse> getClientGuidance() async {
    try {
      final response =
          await dioClient.get<dynamic>('/messaging/client-guidance');
      final raw = response.data;
      if (raw is! Map) {
        throw const FormatException('Configuration de guidage invalide');
      }
      final envelope = Map<String, dynamic>.from(raw);
      final payload = envelope['data'] is Map
          ? Map<String, dynamic>.from(envelope['data'] as Map)
          : envelope;
      final guidance = ClientGuidanceResponse.fromJson(payload);
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        _guidanceCacheKey,
        jsonEncode(guidance.toJson()),
      );
      log('[ClientGuidance] GET /messaging/client-guidance succeeded (${guidance.rules.length} active rule(s))');
      return guidance;
    } catch (error, stackTrace) {
      log('[ClientGuidance] GET /messaging/client-guidance failed',
          error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Somme du non-lu sur les 3 types — alimente le badge de l'onglet
  /// Messages (`GET /conversations/counts` n'a pas de ligne "toutes").
  Future<int> getTotalUnreadCount() async {
    try {
      final counts = await getConversationCounts();
      return counts.fold<int>(0, (total, c) => total + c.unread);
    } catch (error) {
      log('Error: $error');
      return 0;
    }
  }
}
