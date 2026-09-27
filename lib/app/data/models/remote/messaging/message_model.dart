import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

enum MessageSenderRole {
  client('client'),
  pro('pro');

  final String value;
  const MessageSenderRole(this.value);

  static MessageSenderRole fromString(String? value) {
    return MessageSenderRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MessageSenderRole.pro,
    );
  }
}

@freezed
class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    required String id,
    required String conversationId,
    String? senderId,
    @Default('pro') String senderRole,
    @Default('text') String type,
    required String content,
    String? moderationStatus,
    DateTime? readAt,
    DateTime? createdAt,

    /// Id temporaire côté client (envoi optimiste), jamais renvoyé par
    /// l'API — sert uniquement à réconcilier la bulle locale avec la
    /// version confirmée par le serveur (`message_new`/ACK `send_message`).
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? clientTempId,

    /// État d'envoi purement local (spec §5.4) : sending/sent/failed.
    /// Absent du JSON — jamais renvoyé par le backend.
    @Default(MessageDeliveryState.sent)
    @JsonKey(includeFromJson: false, includeToJson: false)
    MessageDeliveryState deliveryState,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  MessageSenderRole get senderRoleEnum => MessageSenderRole.fromString(senderRole);

  bool get isFromClient => senderRoleEnum == MessageSenderRole.client;
}

enum MessageDeliveryState {
  sending,
  sent,
  failed,
}
