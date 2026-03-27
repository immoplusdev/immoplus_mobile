import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_change_models.freezed.dart';
part 'contact_change_models.g.dart';

@freezed
class RequestContactChangeBody with _$RequestContactChangeBody {
  const factory RequestContactChangeBody({
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'phoneNumber') String? phoneNumber,
    @JsonKey(name: 'email') String? email,
  }) = _RequestContactChangeBody;

  factory RequestContactChangeBody.fromJson(Map<String, dynamic> json) =>
      _$RequestContactChangeBodyFromJson(json);
}

@freezed
class ConfirmContactChangeBody with _$ConfirmContactChangeBody {
  const factory ConfirmContactChangeBody({
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'otp') required String code,
  }) = _ConfirmContactChangeBody;

  factory ConfirmContactChangeBody.fromJson(Map<String, dynamic> json) =>
      _$ConfirmContactChangeBodyFromJson(json);
}

@freezed
class ContactChangeResponseData with _$ContactChangeResponseData {
  const factory ContactChangeResponseData({
    @JsonKey(name: 'message') required String message,
  }) = _ContactChangeResponseData;

  factory ContactChangeResponseData.fromJson(Map<String, dynamic> json) =>
      _$ContactChangeResponseDataFromJson(json);
}

@freezed
class ContactChangeResponse with _$ContactChangeResponse {
  const factory ContactChangeResponse({
    @JsonKey(name: 'data') required ContactChangeResponseData data,
  }) = _ContactChangeResponse;

  factory ContactChangeResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactChangeResponseFromJson(json);
}
