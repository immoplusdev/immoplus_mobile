import 'package:freezed_annotation/freezed_annotation.dart';

part 'commune_model.freezed.dart';
part 'commune_model.g.dart';

@freezed
class CommuneModel with _$CommuneModel {
  const factory CommuneModel({
    @Default('') String id,
    @Default('') String name,
    @Default(null) DateTime? createdAt,
    @Default(null) DateTime? updatedAt,
    @Default(null) DateTime? deletedAt,
    @Default(null) String? createdBy,
    @Default('') String villeId,
  }) = _CommuneModel;

  factory CommuneModel.fromJson(Map<String, dynamic> json) =>
      _$CommuneModelFromJson(json);
}
