import 'package:freezed_annotation/freezed_annotation.dart';

enum RatingStatus {
  @JsonValue('not_applicable')
  not_applicable('not_applicable'),
  @JsonValue('pending')
  pending('pending'),
  @JsonValue('rated')
  rated('rated'),
  @JsonValue('expired')
  expired('expired');

  final String value;
  const RatingStatus(this.value);

  static RatingStatus? fromString(String? value) {
    if (value == null) return null;
    return RatingStatus.values.where((e) => e.value == value).firstOrNull;
  }
}
