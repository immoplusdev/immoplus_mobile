import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus/app/features/notification/model/notifications_response.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_provider.g.dart';

@RestApi(baseUrl: null)
abstract class NotificationProvider {
  factory NotificationProvider(Dio dio, {String baseUrl}) =
      _NotificationProvider;

  @GET('/notifications')
  Future<NotificationsResponse> getNotifications(
      {@Query('page') int page = 1,
      @Query('pageSize') int pageSize = 10,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir});

  @PUT('/notifications/{id}/read')
  Future<HttpResponse> markAsRead(@Path() String id);

  @PUT('/notifications/mark-all-read')
  Future<HttpResponse> markAllAsRead();

  @DELETE('/notifications/{id}')
  Future<HttpResponse> deleteNotification(@Path() String id);

  @GET('/notifications/unread-count')
  Future<HttpResponse> getUnreadCount();
}
