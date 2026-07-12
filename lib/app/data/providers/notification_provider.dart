import 'package:dio/dio.dart';
import 'package:immoplus/app/features/notification/model/notification_model.dart';
import 'package:immoplus/app/features/notification/model/notifications_response.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_provider.g.dart';

@RestApi()
abstract class NotificationProvider {
  factory NotificationProvider(Dio dio, {String baseUrl}) =
      _NotificationProvider;

  @GET('/notifications/me')
  Future<NotificationsResponse> getNotifications({
    @Query('pushType') String? pushType,
    @Query('onlyUnread') bool? onlyUnread,
    @Query('_page') int page = 1,
    @Query('_per_page') int pageSize = 20,
  });

  @GET('/notifications/me/unread-count')
  Future<HttpResponse> getUnreadCount();

  @GET('/notifications/{id}')
  Future<NotificationModel> getNotificationById(@Path('id') String id);

  @PATCH('/notifications/{id}')
  Future<HttpResponse> updateNotification(
      @Path('id') String id, @Body() Map<String, dynamic> body);

  @DELETE('/notifications/{id}')
  Future<HttpResponse> deleteNotification(@Path('id') String id);

  @PATCH('/notifications/{id}/read')
  Future<HttpResponse> markAsRead(@Path('id') String id);

  @PATCH('/notifications/me/read-all')
  Future<HttpResponse> markAllAsRead();

  @DELETE('/notifications/me/{id}')
  Future<HttpResponse> deleteMyNotification(@Path('id') String id);
}
