import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_cubit_state.freezed.dart';

@freezed
class DeleteAccountState with _$DeleteAccountState {
  const factory DeleteAccountState.initial() = _Initial;
  const factory DeleteAccountState.loading() = _Loading;
  const factory DeleteAccountState.success() = _Success;
  const factory DeleteAccountState.error(String message) = _Error;
}
