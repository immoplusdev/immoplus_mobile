import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

enum ConversationStatus {
  active('active'),
  blocked('blocked');

  final String value;
  const ConversationStatus(this.value);

  static ConversationStatus fromString(String? value) {
    return ConversationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ConversationStatus.active,
    );
  }
}

enum ConversationType {
  reservation('reservation'),
  visite('visite'),
  support('support'),
  relais('relais');

  final String value;
  const ConversationType(this.value);

  static ConversationType fromString(String? value) {
    return ConversationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ConversationType.reservation,
    );
  }
}

@freezed
class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  const factory ConversationModel({
    required String id,
    @Default('reservation') String type,

    /// Non-null seulement pour `type == reservation`.
    String? residenceId,

    /// Non-null seulement pour `type == visite`.
    String? visiteId,

    /// Non-null seulement pour `type == relais`.
    String? relaisId,

    /// Toujours `null` pour `type == support` (boîte partagée, pas
    /// d'interlocuteur fixe).
    String? proId,
    required String clientId,
    @Default('active') String status,
    @Default(0) int unreadCountClient,
    @Default(0) int unreadCountPro,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    DateTime? createdAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  ConversationStatus get statusEnum => ConversationStatus.fromString(status);
  ConversationType get typeEnum => ConversationType.fromString(type);
}
