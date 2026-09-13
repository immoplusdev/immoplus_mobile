import 'package:freezed_annotation/freezed_annotation.dart';

import 'conversation_model.dart';

part 'conversation_type_count.freezed.dart';
part 'conversation_type_count.g.dart';

/// Une entrée de `GET /conversations/counts` — pas de ligne "toutes", à
/// sommer côté front pour le badge "Toutes"/tab bar.
@freezed
class ConversationTypeCount with _$ConversationTypeCount {
  const ConversationTypeCount._();

  const factory ConversationTypeCount({
    required String type,
    @Default(0) int total,
    @Default(0) int unread,
  }) = _ConversationTypeCount;

  factory ConversationTypeCount.fromJson(Map<String, dynamic> json) =>
      _$ConversationTypeCountFromJson(json);

  ConversationType get typeEnum => ConversationType.fromString(type);
}
