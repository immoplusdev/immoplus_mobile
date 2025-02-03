import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/auth/account_creation_response.dart';

part 'registration_cubit_state.freezed.dart';
part 'registration_cubit_state.g.dart';

@freezed
class RegistrationCubitState with _$RegistrationCubitState {
  // factory RegistrationCubitState() = _RegistrationCubitState;
  const factory RegistrationCubitState.initial() = REGISTRATION_INITIAL;
  const factory RegistrationCubitState.loading() = REGISTRATION_LOADING;
  const factory RegistrationCubitState.error() = REGISTRATION_ERROR;
  const factory RegistrationCubitState.success(
          {required AccountCreationResponse accountCreationResponse}) =
      REGISTRATION_SUCCESS;

  factory RegistrationCubitState.fromJson(Map<String, dynamic> json) =>
      _$RegistrationCubitStateFromJson(json);
}
