import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_cubit_state.freezed.dart';
part 'reset_password_cubit_state.g.dart';

@freezed
class ResetPasswordCubitState with _$ResetPasswordCubitState {
  const factory ResetPasswordCubitState.initial() = RESET_PASSWORD_INITIAL;
  const factory ResetPasswordCubitState.sendingEmailOtp() =
      RESET_PASSWORD_SENDING_EMAIL_OTP;
  const factory ResetPasswordCubitState.emailOtpSent({String? message}) =
      RESET_PASSWORD_EMAIL_OTP_SENT;
  const factory ResetPasswordCubitState.verifyingEmail() =
      RESET_PASSWORD_VERIFYING_EMAIL;
  const factory ResetPasswordCubitState.emailVerified() =
      RESET_PASSWORD_EMAIL_VERIFIED;
  const factory ResetPasswordCubitState.resettingPassword() =
      RESET_PASSWORD_RESETTING_PASSWORD;
  const factory ResetPasswordCubitState.passwordResetSuccess(
      {String? message}) = RESET_PASSWORD_SUCCESS;
  const factory ResetPasswordCubitState.error({String? errorMessage}) =
      RESET_PASSWORD_ERROR;

  factory ResetPasswordCubitState.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordCubitStateFromJson(json);
}
