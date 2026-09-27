import 'package:freezed_annotation/freezed_annotation.dart';

import 'conversation_model.dart';
import 'message_model.dart';

part 'create_conversation_response.freezed.dart';
part 'create_conversation_response.g.dart';

/// Réponse de `POST /conversations` (`201` nouveau fil ou `200` fil repris).
@freezed
class CreateConversationResponse with _$CreateConversationResponse {
  const factory CreateConversationResponse({
    required ConversationModel conversation,
    required MessageModel message,
  }) = _CreateConversationResponse;

  factory CreateConversationResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationResponseFromJson(json);
}
