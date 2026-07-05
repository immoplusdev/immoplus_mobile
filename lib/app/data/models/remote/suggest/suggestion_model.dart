import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iconsax/iconsax.dart';

part 'suggestion_model.freezed.dart';
part 'suggestion_model.g.dart';

enum SuggestionType {
  @JsonValue('ville')
  ville,
  @JsonValue('commune')
  commune,
  @JsonValue('residence')
  residence,
  @JsonValue('bien')
  bien,
  @JsonValue('query')
  query,
  @JsonValue('price')
  price,
  @JsonValue('unknown')
  unknown;

  IconData get icon => switch (this) {
    SuggestionType.ville => Iconsax.map,
    SuggestionType.commune => Iconsax.location,
    SuggestionType.residence => Iconsax.home_1,
    SuggestionType.bien => Iconsax.building,
    SuggestionType.query => Iconsax.search_normal_1,
    SuggestionType.price => Iconsax.wallet_3,
    _ => Iconsax.search_normal,
  };
}

@freezed
class SuggestionModel with _$SuggestionModel {
  const factory SuggestionModel({
    String? id,
    @JsonKey(unknownEnumValue: SuggestionType.unknown) SuggestionType? type,
    String? label,
    String? sublabel,
    double? score,
    String? highlight,
    @JsonKey(name: 'miniature_url') String? miniatureUrl,
    int? prix,
    @JsonKey(name: 'views_count') int? viewsCount,
  }) = _SuggestionModel;

  factory SuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SuggestionModelFromJson(json);
}
