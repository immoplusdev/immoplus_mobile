import 'package:dio/dio.dart';
import 'package:immoplus/app/features/notification/model/notification_model.dart';
import 'package:immoplus/app/features/notification/model/notifications_response.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_provider.g.dart';

@RestApi()
abstract class NotificationProvider {
  factory NotificationProvider(Dio dio, {String baseUrl}) = _NotificationProvider;

  @GET('/notifications/me')
  Future<NotificationsResponse> getNotifications({
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 10,
    @Query('_order_by') String? orderBy,
    @Query('_order_dir') String? orderDir,
  });

  @GET('/notifications/me/unread-count')
  Future<HttpResponse> getUnreadCount();

  @GET('/notifications/{id}')
  Future<NotificationModel> getNotificationById(@Path('id') String id);

  @PATCH('/notifications/{id}')
  Future<HttpResponse> updateNotification(@Path('id') String id, @Body() Map<String, dynamic> body);

  @DELETE('/notifications/{id}')
  Future<HttpResponse> deleteNotification(@Path('id') String id);

  @PATCH('/notifications/{id}/read')
  Future<HttpResponse> markAsRead(@Path('id') String id);

  @PATCH('/notifications/me/read-all')
  Future<HttpResponse> markAllAsRead();

  @DELETE('/notifications/me/{id}')
  Future<HttpResponse> deleteMyNotification(@Path('id') String id);
}
