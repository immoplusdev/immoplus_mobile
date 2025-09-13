import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/features/notification/model/notifications_response.dart';

part 'notification_cubit_state.freezed.dart';

@freezed
class NotificationCubitState with _$NotificationCubitState {
  const factory NotificationCubitState.loading() = _Loading;
  const factory NotificationCubitState.loaded({
    required NotificationsResponse notifications,
    required bool isLoadingMore,
  }) = _Loaded;
  const factory NotificationCubitState.error(String message) = _Error;
}
