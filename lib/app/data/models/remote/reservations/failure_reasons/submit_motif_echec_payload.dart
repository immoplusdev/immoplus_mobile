import 'package:freezed_annotation/freezed_annotation.dart';

part 'submit_motif_echec_payload.freezed.dart';
part 'submit_motif_echec_payload.g.dart';

@freezed
class SubmitMotifEchecPayload with _$SubmitMotifEchecPayload {
  const factory SubmitMotifEchecPayload({
    required String reasonCode,
    String? comment,
  }) = _SubmitMotifEchecPayload;

  factory SubmitMotifEchecPayload.fromJson(Map<String, dynamic> json) =>
      _$SubmitMotifEchecPayloadFromJson(json);
}
