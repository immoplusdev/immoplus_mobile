import 'package:freezed_annotation/freezed_annotation.dart';
import 'furniture_model.dart';

part 'furniture_response.freezed.dart';
part 'furniture_response.g.dart';

@freezed
class FurnitureResponse with _$FurnitureResponse {
  const factory FurnitureResponse({
    @Default('') String message,
    @Default(false) bool status,
    FurnitureModel? data,
  }) = _FurnitureResponse;

  factory FurnitureResponse.fromJson(Map<String, dynamic> json) =>
      _$FurnitureResponseFromJson(json);
}
