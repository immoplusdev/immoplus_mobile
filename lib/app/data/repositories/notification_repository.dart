import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/exceptions/request_response_exeption.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/data/providers/notification_provider.dart';
import 'package:immoplus/app/features/notification/model/notification_model.dart';
import 'package:immoplus/app/features/notification/model/notifications_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

@injectable
class NotificationRepository {
  final Dio dioClient;
  NotificationRepository(this.dioClient);

  Future<NotificationsResponse> getNotifications({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await NotificationProvider(dioClient).getNotifications(
        page: page,
        pageSize: pageSize,
        // orderBy: OrderByField.createdAt.value,
        // orderDir: OrderDir.desc.value,
      );
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load notifications: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load notifications: $error');
    }
  }

  Future<NotificationModel> getNotificationById(String id) async {
    try {
      final response =
          await NotificationProvider(dioClient).getNotificationById(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to load notification detail: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load notification detail: $error');
    }
  }

  Future<HttpResponse> markAsRead(String notificationId) async {
    try {
      final response =
          await NotificationProvider(dioClient).markAsRead(notificationId);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to mark notification as read: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to mark notification as read: $error');
    }
  }

  Future<HttpResponse> markAllAsRead() async {
    try {
      final response = await NotificationProvider(dioClient).markAllAsRead();
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to mark all notifications as read: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to mark all notifications as read: $error');
    }
  }

  Future<HttpResponse> deleteNotification(String notificationId) async {
    try {
      final response = await NotificationProvider(dioClient)
          .deleteMyNotification(notificationId);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to delete notification: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to delete notification: $error');
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await NotificationProvider(dioClient).getUnreadCount();
      // Supposons que la réponse contient un champ 'count' ou 'unread_count'
      if (response.data is Map) {
        return response.data['count'] ?? response.data['unread_count'] ?? 0;
      }
      return 0;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to get unread count: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to get unread count: $error');
    }
  }
}
