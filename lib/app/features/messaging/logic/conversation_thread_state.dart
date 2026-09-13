import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/services/messaging_socket_service.dart';
import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/models/remote/messaging/message_model.dart';

part 'conversation_thread_state.freezed.dart';

@freezed
class ConversationThreadState with _$ConversationThreadState {
  const factory ConversationThreadState.loading() = ConversationThreadLoading;

  const factory ConversationThreadState.loaded({
    required ConversationModel conversation,

    /// Ordre chronologique (plus ancien en premier) — déjà inversé par
    /// rapport à l'ordre renvoyé par l'API.
    required List<MessageModel> messages,
    PeerPresence? peerPresence,
    @Default(false) bool peerTyping,
    DateTime? peerLastReadAt,
    String? moderationBannerMessage,
  }) = ConversationThreadLoaded;

  const factory ConversationThreadState.error(String message) =
      ConversationThreadError;
}
