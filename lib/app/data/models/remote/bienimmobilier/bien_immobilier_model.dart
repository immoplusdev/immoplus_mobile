import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/configs/commune_model.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_model.dart';

import '../residence/commodite_model.dart';
import '../residence/piece_model.dart';
import '../residence/position_model.dart';

part 'bien_immobilier_model.freezed.dart';
part 'bien_immobilier_model.g.dart';

@freezed
class BienImmobilierModel with _$BienImmobilierModel {
  factory BienImmobilierModel({
    @Default('') String id,
    @Default('') String nom,
    @Default('') String typeBienImmobilier,
    @Default('') String typeLocation,
    @Default('') String description,
    @Default([]) List<CommoditeModel> amentities,
    @Default([]) List<String> tags,
    @Default([]) List<String> images,
    @Default('') String adresse,
    @Default(PositionModel()) PositionModel position,
    @Default('') String statusValidation,
    @Default(0) int prix,
    @Default(false) bool featured,
    @Default(true) bool bienImmobilierDisponible,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    @Default('') String miniatureId,
    @Default([]) List<PieceModel> pieces,
    @Default('') String? ville,
    @Default('') String? commune,
    @JsonKey(name: 'ville_model') VilleModel? villeModel,
    @JsonKey(name: 'commune_model') CommuneModel? communeModel,
    @Default('') String? video,
    @Default(false) bool aLouer,
    // 🔥 Ces champs manquants
    @JsonKey(fromJson: toDouble) double? latitude,
    @JsonKey(fromJson: toDouble) double? longitude,
    @JsonKey(fromJson: toInt) int? nombreMaxOccupants,
    @JsonKey(defaultValue: false) bool? fetesAutorises,
    num? score,
  }) = _BienImmobilierModel;

  factory BienImmobilierModel.fromJson(Map<String, dynamic> json) =>
      _$BienImmobilierModelFromJson(json);
}
