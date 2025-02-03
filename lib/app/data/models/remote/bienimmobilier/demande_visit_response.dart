import 'package:freezed_annotation/freezed_annotation.dart';

import 'demande_visite_model.dart';

part 'demande_visit_response.freezed.dart';
part 'demande_visit_response.g.dart';

@freezed
class DemandeVisitResponse with _$DemandeVisitResponse {
  factory DemandeVisitResponse({
    required DemandeVisiteModel data,
  }) = _DemandeVisitResponse;

  factory DemandeVisitResponse.fromJson(Map<String, dynamic> json) =>
      _$DemandeVisitResponseFromJson(json);
}
