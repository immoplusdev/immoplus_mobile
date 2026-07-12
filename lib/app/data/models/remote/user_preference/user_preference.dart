import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preference.freezed.dart';
part 'user_preference.g.dart';

@freezed
class UserPreferenceResponse with _$UserPreferenceResponse {
  const factory UserPreferenceResponse({
    UserPreferenceModel? data,
  }) = _UserPreferenceResponse;

  factory UserPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceResponseFromJson(json);
}

@freezed
class UserPreferenceModel with _$UserPreferenceModel {
  const factory UserPreferenceModel({
    required String? id,
    PreferenceIntent? intent,
    required List<PreferencePropertyType> propertyTypes,
    required List<PreferenceLocation> locations,
    double? budgetMin,
    double? budgetMax,
  }) = _UserPreferenceModel;

  factory UserPreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceModelFromJson(json);
}

@freezed
class PreferenceIntent with _$PreferenceIntent {
  const factory PreferenceIntent({
    required String id,
    String? code,
    String? name,
  }) = _PreferenceIntent;

  factory PreferenceIntent.fromJson(Map<String, dynamic> json) =>
      _$PreferenceIntentFromJson(json);
}

@freezed
class PreferencePropertyType with _$PreferencePropertyType {
  const factory PreferencePropertyType({
    required String id,
    String? code,
    String? name,
  }) = _PreferencePropertyType;

  factory PreferencePropertyType.fromJson(Map<String, dynamic> json) =>
      _$PreferencePropertyTypeFromJson(json);
}

@freezed
class PreferenceLocation with _$PreferenceLocation {
  const factory PreferenceLocation({
    required String id,
    String? name,
  }) = _PreferenceLocation;

  factory PreferenceLocation.fromJson(Map<String, dynamic> json) =>
      _$PreferenceLocationFromJson(json);
}

@freezed
class UserPreferenceRequest with _$UserPreferenceRequest {
  const factory UserPreferenceRequest({
    String? intentId,
    required List<String> propertyTypeIds,
    required List<String> locationIds,
    double? budgetMin,
    double? budgetMax,
  }) = _UserPreferenceRequest;

  factory UserPreferenceRequest.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceRequestFromJson(json);
}
