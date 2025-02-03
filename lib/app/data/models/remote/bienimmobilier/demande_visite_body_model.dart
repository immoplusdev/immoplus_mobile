import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_demande_visite.dart';

part 'demande_visite_body_model.freezed.dart';
part 'demande_visite_body_model.g.dart';

@freezed
class DemandeVisiteBodyModel with _$DemandeVisiteBodyModel {
  const factory DemandeVisiteBodyModel({
    @Default('') String bienImmobilier,
    @Default('') String typeDemandeVisite,
    @Default([]) List<DateDemandeVisite> datesDemandeVisite,
    @Default('') String clientPhoneNumber,
    @Default('') String notes,
  }) = _DemandeVisiteBodyModel;

  factory DemandeVisiteBodyModel.fromJson(Map<String, dynamic> json) =>
      _$DemandeVisiteBodyModelFromJson(json);
}
