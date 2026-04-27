import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/repositories/notification_repository.dart';
import 'package:immoplus/app/features/notification/cubit/notification_cubit_state.dart';
import 'package:immoplus/app/features/notification/model/notification_model.dart';
import 'package:immoplus/app/features/notification/model/notifications_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationCubit extends Cubit<NotificationCubitState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository)
      : super(const NotificationCubitState.loading());

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
        emit(NotificationCubitState.loaded(
          notifications: _currentNotifications!,
          isLoadingMore: false,
        ));
        return;
      } else {
        emit(const NotificationCubitState.loading());
      }

      final response = await _repository.getNotifications(page: _currentPage);

      if (refresh || _currentNotifications == null) {
        _currentNotifications = response;
      } else {
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
    } catch (e) {
      log(e.toString(), name: "NOTIFICATION_ERROR");
      emit(NotificationCubitState.error(
          e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// Charger plus (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || _currentNotifications == null) return;

    emit(NotificationCubitState.loaded(
      notifications: _currentNotifications!,
      isLoadingMore: true,
    ));

    try {
      final response = await _repository.getNotifications(page: _currentPage);

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
    } catch (e) {
      log(e.toString(), name: "LOAD_MORE_ERROR");
      emit(NotificationCubitState.loaded(
        notifications: _currentNotifications!,
        isLoadingMore: false,
      ));
    }
  }

  /// Marquer comme lu
  Future<void> markAsRead(String notificationId) async {
    if (_currentNotifications == null) return;

    try {
      await _repository.markAsRead(notificationId);

      final updatedData = _currentNotifications!.data.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(readAt: DateTime.now());
        }
        return n;
      }).toList();

      _currentNotifications =
          _currentNotifications!.copyWith(data: updatedData);

      emit(NotificationCubitState.loaded(
        notifications: _currentNotifications!,
        isLoadingMore: false,
      ));
    } catch (e) {
      log(e.toString(), name: "MARK_READ_ERROR");
    }
  }

  /// Tout marquer comme lu
  Future<void> markAllAsRead() async {
    if (_currentNotifications == null) return;

    try {
      await _repository.markAllAsRead();

      final updatedData = _currentNotifications!.data.map((n) {
        return n.copyWith(readAt: DateTime.now());
      }).toList();

      _currentNotifications =
          _currentNotifications!.copyWith(data: updatedData);

      emit(NotificationCubitState.loaded(
        notifications: _currentNotifications!,
        isLoadingMore: false,
      ));
    } catch (e) {
      log(e.toString(), name: "MARK_ALL_READ_ERROR");
    }
  }

  /// Supprimer une notification
  Future<void> deleteNotification(String notificationId) async {
    if (_currentNotifications == null) return;

    try {
      await _repository.deleteNotification(notificationId);

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
    } catch (e) {
      log(e.toString(), name: "DELETE_ERROR");
    }
  }

  Future<void> refresh() => loadNotifications(refresh: true);
}
