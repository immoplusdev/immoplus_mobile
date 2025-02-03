import 'package:freezed_annotation/freezed_annotation.dart';

part 'demande_visit_request_body.freezed.dart';
part 'demande_visit_request_body.g.dart';

@freezed
class DemandeVisitRequestBody with _$DemandeVisitRequestBody {
  factory DemandeVisitRequestBody({
    required String bienImmobilier,
    required String typeDemandeVisite,
    required String clientPhoneNumber,
    //String? notes,
  }) = _DemandeVisitRequestBody;

  factory DemandeVisitRequestBody.fromJson(Map<String, dynamic> json) =>
      _$DemandeVisitRequestBodyFromJson(json);
}
