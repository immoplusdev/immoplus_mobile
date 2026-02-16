import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/configs/commune_model.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_model.dart';
import '../residence/position_model.dart';

part 'furniture_model.freezed.dart';
part 'furniture_model.g.dart';

@freezed
class FurnitureModel with _$FurnitureModel {
  const factory FurnitureModel({
    @Default('') String id,
    @Default('') String titre,
    @Default(0) int prix,
    @Default('') String description,
    @Default('') String adresse,
    @Default([]) List<String> images,
    FurnitureMetadata? metadata,
    @Default('') String video,
    @Default('') String? type,
    @Default('') String? category,
    @Default('') String? etat,
    @Default('') String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default('') String? ville,
    @Default('') String? commune,
    @Default('') String ownerPhoneNumber,
    @JsonKey(name: 'ville_model') VilleModel? villeModel,
    @JsonKey(name: 'commune_model') CommuneModel? communeModel,
    @Default(PositionModel()) PositionModel position,
    @Default(true) bool available,
  }) = _FurnitureModel;

  factory FurnitureModel.fromJson(Map<String, dynamic> json) =>
      _$FurnitureModelFromJson(json);
}

@freezed
class FurnitureMetadata with _$FurnitureMetadata {
  const factory FurnitureMetadata({
    @Default([]) List<String> colors,
  }) = _FurnitureMetadata;

  factory FurnitureMetadata.fromJson(Map<String, dynamic> json) =>
      _$FurnitureMetadataFromJson(json);
}
