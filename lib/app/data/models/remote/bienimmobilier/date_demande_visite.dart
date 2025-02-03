import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_demande_visite.freezed.dart';
part 'date_demande_visite.g.dart';

@freezed
class DateDemandeVisite with _$DateDemandeVisite {
  const factory DateDemandeVisite({
    DateTime? date,
  }) = _DateDemandeVisite;

  factory DateDemandeVisite.fromJson(Map<String, dynamic> json) =>
      _$DateDemandeVisiteFromJson(json);
}
