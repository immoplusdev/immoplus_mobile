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

/// Action calculée par le serveur pour le lecteur courant. Le client ne doit
/// jamais créer ces actions lui-même : il affiche seulement celles reçues.
class MessagingAction {
  const MessagingAction({
    required this.id,
    required this.label,
    required this.variant,
    this.target = const {},
  });

  final String id;
  final String label;
  final String variant;
  final Map<String, dynamic> target;

  factory MessagingAction.fromJson(Map<String, dynamic> json) =>
      MessagingAction(
        id: json['id']?.toString() ?? '',
        label: json['label']?.toString() ?? 'Continuer',
        variant: json['variant']?.toString() ?? 'secondary',
        target: json['target'] is Map
            ? Map<String, dynamic>.from(json['target'] as Map)
            : const {},
      );
}

class _MessageServerMetadata {
  const _MessageServerMetadata({
    this.payload = const {},
    this.actions = const [],
    this.suggestedReplies = const [],
    this.audience,
  });

  final Map<String, dynamic> payload;
  final List<MessagingAction> actions;
  final List<String> suggestedReplies;
  final String? audience;
}

final _metadataByMessageId = <String, _MessageServerMetadata>{};

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
    @JsonKey(includeFromJson: false, includeToJson: false) String? clientTempId,

    /// État d'envoi purement local (spec §5.4) : sending/sent/failed.
    /// Absent du JSON — jamais renvoyé par le backend.
    @Default(MessageDeliveryState.sent)
    @JsonKey(includeFromJson: false, includeToJson: false)
    MessageDeliveryState deliveryState,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(_processJson(json));

  static Map<String, dynamic> _processJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    _metadataByMessageId[id] = _MessageServerMetadata(
      payload: json['payload'] is Map
          ? Map<String, dynamic>.from(json['payload'] as Map)
          : const {},
      actions: (json['actions'] as List? ?? const [])
          .whereType<Map>()
          .map((action) =>
              MessagingAction.fromJson(Map<String, dynamic>.from(action)))
          .toList(growable: false),
      suggestedReplies: (json['suggestedReplies'] as List? ?? const [])
          .map((reply) => reply.toString())
          .where((reply) => reply.isNotEmpty)
          .toList(growable: false),
      audience: json['audience']?.toString(),
    );
    return json;
  }

  Map<String, dynamic> get payload =>
      _metadataByMessageId[id]?.payload ?? const {};
  List<MessagingAction> get actions =>
      _metadataByMessageId[id]?.actions ?? const [];
  List<String> get suggestedReplies =>
      _metadataByMessageId[id]?.suggestedReplies ?? const [];
  String? get audience => _metadataByMessageId[id]?.audience;

  static void patchServerMetadata(
    String messageId, {
    List<MessagingAction>? actions,
    List<String>? suggestedReplies,
    Map<String, dynamic>? payloadPatch,
  }) {
    final previous =
        _metadataByMessageId[messageId] ?? const _MessageServerMetadata();
    _metadataByMessageId[messageId] = _MessageServerMetadata(
      actions: actions ?? previous.actions,
      suggestedReplies: suggestedReplies ?? previous.suggestedReplies,
      payload: {...previous.payload, ...?payloadPatch},
      audience: previous.audience,
    );
  }

  MessageSenderRole get senderRoleEnum =>
      MessageSenderRole.fromString(senderRole);

  bool get isFromClient => senderRoleEnum == MessageSenderRole.client;
}

enum MessageDeliveryState {
  sending,
  sent,
  failed,
}
