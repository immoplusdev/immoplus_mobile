import 'package:freezed_annotation/freezed_annotation.dart';
import 'kyc_session_create_model.dart';

part 'kyc_session_create_response.freezed.dart';
part 'kyc_session_create_response.g.dart';

@freezed
class KycSessionCreateResponse with _$KycSessionCreateResponse {
  const factory KycSessionCreateResponse({
    required KycSessionCreateModel data,
  }) = _KycSessionCreateResponse;

  factory KycSessionCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$KycSessionCreateResponseFromJson(json);
}
