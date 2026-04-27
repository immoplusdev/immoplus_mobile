import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/user_preference/user_preference.dart';
import 'package:immoplus/app/data/models/remote/user_preference/user_preference_options.dart';

part 'user_preference_cubit_state.freezed.dart';

@freezed
class UserPreferenceCubitState with _$UserPreferenceCubitState {
  const factory UserPreferenceCubitState.initial() = _Initial;
  const factory UserPreferenceCubitState.loading() = _Loading;
  const factory UserPreferenceCubitState.loaded({
    required UserPreferenceOptionsList options,
    String? selectedIntentId,
    required List<String> selectedPropertyTypeIds,
    required List<String> selectedLocationIds,
    double? budgetMin,
    double? budgetMax,
    @Default(false) bool isSaving,
  }) = _Loaded;
  const factory UserPreferenceCubitState.success() = _Success;
  const factory UserPreferenceCubitState.error(String message) = _Error;
}
