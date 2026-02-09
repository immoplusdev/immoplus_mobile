import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/configs/commune_model.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_model.dart';

import 'commodite_model.dart';
import 'piece_model.dart';
import 'position_model.dart';

part 'residence_model.freezed.dart';
part 'residence_model.g.dart';

@freezed
class ResidenceModel with _$ResidenceModel {
  const factory ResidenceModel({
    @Default('') String id,
    @Default('') String miniature,
    @Default('') String nom,
    @Default('Appartement') String typeResidence,
    @Default('') String description,
    @Default(0) int prixReservation,
    @Default('') String adresse,
    @Default('') String ville,
    @Default('') String commune,
    @JsonKey(name: 'ville_model') VilleModel? villeModel,
    @JsonKey(name: 'commune_model') CommuneModel? communeModel,
    @Default(PositionModel()) PositionModel position,
    @Default('') String video,
    @Default([]) List<String> images,
    @Default([]) List<CommoditeModel> commodites,
    @Default([]) List<PieceModel> pieces,
    @Default(0) int dureeMinSejour,
    @Default(0) int dureeMaxSejour,
    @Default('') String heureEntree,
    @Default('') String heureDepart,
    @Default(0) int nombreMaxOccupants,
    @Default(false) bool animauxAutorises,
    @Default(false) bool fetesAutorises,
    @Default('') String reglesSupplementaires,
    //ClientModel? proprietaire,
    @Default(true) bool residenceDisponible,
  }) = _ResidenceModel;

  factory ResidenceModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceModelFromJson(json);
}
