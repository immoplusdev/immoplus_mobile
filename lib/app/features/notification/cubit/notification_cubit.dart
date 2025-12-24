import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/repositories/notification_repository.dart';
import 'package:immoplus/app/features/notification/cubit/notification_cubit_state.dart';
import 'package:immoplus/app/features/notification/model/notification_model.dart';
import 'package:immoplus/app/features/notification/model/notifications_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationCubit extends Cubit<NotificationCubitState> {
  NotificationCubit() : super(const NotificationCubitState.loading());

  NotificationsResponse? _currentNotifications;
  int _currentPage = 1;
  bool _hasMore = true;

  /// Charger les notifications
  Future<void> loadNotifications({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _hasMore = true;
        _currentNotifications = null;
        emit(const NotificationCubitState.loading());
      } else if (_currentNotifications != null) {
        // On a déjà des données, les afficher
        emit(NotificationCubitState.loaded(
          notifications: _currentNotifications!,
          isLoadingMore: false,
        ));
        return;
      } else {
        emit(const NotificationCubitState.loading());
      }

      final response =
          await NotificationRepository().getNotifications(page: _currentPage);

      if (refresh || _currentNotifications == null) {
        _currentNotifications = response;
      } else {
        // Pagination
        final updatedData =
            List<NotificationModel>.from(_currentNotifications!.data)
              ..addAll(response.data);

        _currentNotifications = _currentNotifications!.copyWith(
          data: updatedData,
          currentPage: response.currentPage,
          hasNext: response.hasNext,
        );
      }

      _hasMore = response.hasNext;
      _currentPage++;

      emit(NotificationCubitState.loaded(
        notifications: _currentNotifications!,
        isLoadingMore: false,
      ));

      log('Notifications loaded, page: ${_currentPage - 1}',
          name: 'NOTIFICATION_CUBIT');
    } catch (e) {
      log(e.toString(), name: "NOTIFICATION_ERROR");
      emit(NotificationCubitState.error(
          e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// Charger plus (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || _currentNotifications == null) return;

    // Afficher le loading en bas pendant qu'on charge
    emit(NotificationCubitState.loaded(
      notifications: _currentNotifications!,
      isLoadingMore: true,
    ));

    try {
      final response =
          await NotificationRepository().getNotifications(page: _currentPage);

      final updatedData =
          List<NotificationModel>.from(_currentNotifications!.data)
            ..addAll(response.data);

      _currentNotifications = _currentNotifications!.copyWith(
        data: updatedData,
        currentPage: response.currentPage,
        hasNext: response.hasNext,
      );

      _hasMore = response.hasNext;
      _currentPage++;

      emit(NotificationCubitState.loaded(
        notifications: _currentNotifications!,
        isLoadingMore: false,
      ));

      log('More notifications loaded, page: ${_currentPage - 1}',
          name: 'NOTIFICATION_CUBIT');
    } catch (e) {
      log(e.toString(), name: "LOAD_MORE_ERROR");
      // En cas d'erreur, remettre l'état sans loading
      emit(NotificationCubitState.loaded(
        notifications: _currentNotifications!,
        isLoadingMore: false,
      ));
    }
  }

  /// Supprimer une notification
  Future<void> deleteNotification(String notificationId) async {
    if (_currentNotifications == null) return;

    try {
      await NotificationRepository().deleteNotification(notificationId);

      // Supprimer localement
      final updatedData = _currentNotifications!.data
          .where((notification) => notification.id != notificationId)
          .toList();

      _currentNotifications = _currentNotifications!.copyWith(
        data: updatedData,
        totalCount: _currentNotifications!.totalCount - 1,
      );

      emit(NotificationCubitState.loaded(
        notifications: _currentNotifications!,
        isLoadingMore: false,
      ));

      log('Notification deleted: $notificationId', name: 'NOTIFICATION_CUBIT');
    } catch (e) {
      log(e.toString(), name: "DELETE_ERROR");
      // Pas besoin d'état d'erreur, la notification reste juste là
    }
  }

  /// Refresh
  Future<void> refresh() => loadNotifications(refresh: true);
}
