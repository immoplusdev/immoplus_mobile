import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preference_options.freezed.dart';
part 'user_preference_options.g.dart';

@freezed
class UserPreferenceOptionsResponse with _$UserPreferenceOptionsResponse {
  const factory UserPreferenceOptionsResponse({
    required UserPreferenceOptionsData data,
  }) = _UserPreferenceOptionsResponse;

  factory UserPreferenceOptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceOptionsResponseFromJson(json);
}

@freezed
class UserPreferenceOptionsData with _$UserPreferenceOptionsData {
  const factory UserPreferenceOptionsData({
    required UserPreferenceOptionsList data,
  }) = _UserPreferenceOptionsData;

  factory UserPreferenceOptionsData.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceOptionsDataFromJson(json);
}

@freezed
class UserPreferenceOptionsList with _$UserPreferenceOptionsList {
  const factory UserPreferenceOptionsList({
    required List<PreferenceOption> propertyTypes,
    required List<PreferenceOption> intents,
    required List<PreferenceOption> locations,
  }) = _UserPreferenceOptionsList;

  factory UserPreferenceOptionsList.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceOptionsListFromJson(json);
}

@freezed
class PreferenceOption with _$PreferenceOption {
  const factory PreferenceOption({
    required String id,
    required String label,
  }) = _PreferenceOption;

  factory PreferenceOption.fromJson(Map<String, dynamic> json) =>
      _$PreferenceOptionFromJson(json);
}
