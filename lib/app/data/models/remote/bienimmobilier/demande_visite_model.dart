import 'package:freezed_annotation/freezed_annotation.dart';

import '../reservations/client_model.dart';
import 'bien_immobilier_model.dart';
import 'date_demande_visite.dart';

part 'demande_visite_model.freezed.dart';
part 'demande_visite_model.g.dart';

@freezed
class DemandeVisiteModel with _$DemandeVisiteModel {
  factory DemandeVisiteModel({
    @Default('') String id,
    String? statusDemandeVisite,
    String? typeDemandeVisite,
    @Default([]) List<DateDemandeVisite> datesDemandeVisite,
    String? statusFacture,
    @Default(false) bool retraitProEffectue,
    @Default(0) int montantTotalDemandeVisite,
    @Default(0) int montantDemandeVisiteSansCommission,
    String? notes,
    String? clientPhoneNumber,
    BienImmobilierModel? bienImmobilier,
    String? bienImmobilierId,
    ClientModel? client,
    ClientModel? proprietaire,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) = _DemandeVisiteModel;

  factory DemandeVisiteModel.fromJson(Map<String, dynamic> json) =>
      _$DemandeVisiteModelFromJson(json);
}
