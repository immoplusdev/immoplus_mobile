import 'package:freezed_annotation/freezed_annotation.dart';

import 'commodite_model.dart';
import 'piece_model.dart';
import 'position_model.dart';

part 'residence_creation_model.freezed.dart';
part 'residence_creation_model.g.dart';

@freezed
class ResidenceCreationModel with _$ResidenceCreationModel {
  const factory ResidenceCreationModel({
    @Default('') String miniature,
    @Default('') String nom,
    @Default('') String typeResidence,
    @Default('') String description,
    @Default(0) int prixReservation,
    @Default('') String adresse,
    @Default('') String ville,
    @Default('') String commune,
    @Default(PositionModel()) PositionModel position,
    @Default('') String video,
    @Default([]) List<String> images,
    @Default([]) List<CommoditeModel> commodites,
    @Default([]) List<PieceModel> pieces,
    @Default(0) int dureeMinSejour,
    @Default(0) int dureeMaxSejour,
    @Default({}) Map<String, dynamic> metadata,
    @Default('') String heureEntree,
    @Default('') String heureDepart,
    @Default(0) int nombreMaxOccupants,
    @Default(false) bool animauxAutorises,
    @Default(false) bool fetesAutorises,
    @Default('') String reglesSupplementaires,
    @Default(true) bool residenceDisponible,
  }) = _ResidenceCreationModel;

  factory ResidenceCreationModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceCreationModelFromJson(json);
}
