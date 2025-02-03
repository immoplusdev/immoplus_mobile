import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_cubit_state.freezed.dart';
part 'login_cubit_state.g.dart';

@freezed
class LoginCubitState with _$LoginCubitState {
  factory LoginCubitState() = _LoginCubitState;
  const factory LoginCubitState.initial() = LOGIN_INITIAL;
  const factory LoginCubitState.loading() = LOGIN_LOADING;
  const factory LoginCubitState.success() = LOGIN_SUCCESS;
  factory LoginCubitState.fromJson(Map<String, dynamic> json) =>
      _$LoginCubitStateFromJson(json);
}
