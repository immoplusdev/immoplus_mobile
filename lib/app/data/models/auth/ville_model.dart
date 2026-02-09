import 'package:freezed_annotation/freezed_annotation.dart';

part 'ville_model.freezed.dart';
part 'ville_model.g.dart';

@freezed
class VilleModel with _$VilleModel {
  const factory VilleModel({
    @Default('') String id,
    @Default('') String name,
    @Default(null) DateTime? createdAt,
    @Default(null) DateTime? updatedAt,
    @Default(null) DateTime? deletedAt,
  }) = _VilleModel;

  factory VilleModel.fromJson(Map<String, dynamic> json) =>
      _$VilleModelFromJson(json);
}
