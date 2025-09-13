import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/exceptions/request_response_exeption.dart';
import 'package:immoplus/app/data/providers/notification_provider.dart';
import 'package:immoplus/app/features/notification/model/notifications_response.dart';
import 'package:retrofit/retrofit.dart';

class NotificationRepository {
  final dioClient = getIt<Dio>();

  Future<NotificationsResponse> getNotifications({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await NotificationProvider(dioClient)
          .getNotifications(page: page, pageSize: pageSize);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load notifications: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load notifications: $error');
    }
  }

  Future<HttpResponse> markAsRead(String notificationId) async {
    try {
      final response =
          await NotificationProvider(dioClient).markAsRead(notificationId);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to mark notification as read: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to mark notification as read: $error');
    }
  }

  Future<HttpResponse> markAllAsRead() async {
    try {
      final response = await NotificationProvider(dioClient).markAllAsRead();
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to mark all notifications as read: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to mark all notifications as read: $error');
    }
  }

  Future<HttpResponse> deleteNotification(String notificationId) async {
    try {
      final response = await NotificationProvider(dioClient)
          .deleteNotification(notificationId);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to delete notification: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to delete notification: $error');
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await NotificationProvider(dioClient).getUnreadCount();
      inspect(response);
      // Supposons que la réponse contient un champ 'count'
      return response.data['count'] ?? 0;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to get unread count: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to get unread count: $error');
    }
  }
}
