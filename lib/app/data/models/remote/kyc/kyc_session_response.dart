import 'package:freezed_annotation/freezed_annotation.dart';
import 'kyc_session_model.dart';

part 'kyc_session_response.freezed.dart';
part 'kyc_session_response.g.dart';

@freezed
class KycSessionResponse with _$KycSessionResponse {
  const factory KycSessionResponse({
    KycSessionModel? data,
  }) = _KycSessionResponse;

  factory KycSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$KycSessionResponseFromJson(json);
}
