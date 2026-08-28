import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/enums/validation_status.dart';
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
    @Default('') String statusValidation,
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
    num? score,
    //ClientModel? proprietaire,
    @Default(true) bool residenceDisponible,
    @Default(0) num reduction,

    /// Montant du séjour pour cette recherche inversée, SANS les frais — présent uniquement dans les payloads reverse-search.
    @JsonKey(name: 'reverse_search_montant') double? reverseSearchMontant,

    /// Prix par nuit, figé au moment de l'envoi de la vague au propriétaire.
    @JsonKey(name: 'reverse_search_prix_par_nuit')
    int? reverseSearchPrixParNuit,

    /// Nombre de nuits du séjour recherché.
    @JsonKey(name: 'reverse_search_nombre_nuits') int? reverseSearchNombreNuits,

    /// Frais de paiement (2%) appliqués à reverseSearchMontant.
    @JsonKey(name: 'reverse_search_frais') double? reverseSearchFrais,

    /// Montant réellement facturé au paiement (reverseSearchMontant + frais).
    @JsonKey(name: 'reverse_search_montant_total')
    double? reverseSearchMontantTotal,
  }) = _ResidenceModel;

  factory ResidenceModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceModelFromJson(json);
}

extension ResidenceModelX on ResidenceModel {
  ValidationStatus get validationStatus =>
      ValidationStatus.fromString(statusValidation);

  bool get hasReduction => reduction > 0;

  /// Prix réduit calculé côté front : prixReservation * (1 - reduction/100).
  int get prixReduit => hasReduction
      ? (prixReservation * (1 - reduction / 100)).round()
      : prixReservation;
}
