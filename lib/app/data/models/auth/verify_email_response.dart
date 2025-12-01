import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_response.freezed.dart';
part 'verify_email_response.g.dart';

@freezed
class VerifyEmailResponse with _$VerifyEmailResponse {
  const factory VerifyEmailResponse({
    required VerifyEmailData data,
  }) = _VerifyEmailResponse;

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailResponseFromJson(json);
}

@freezed
class VerifyEmailData with _$VerifyEmailData {
  const factory VerifyEmailData({
    @Default(false) bool? success,
    @Default('') String? token,
    @Default('') String? email,
  }) = _VerifyEmailData;

  factory VerifyEmailData.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailDataFromJson(json);
}
