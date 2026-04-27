import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus/app/data/models/remote/alert/alert_request.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_response.dart';
import 'package:immoplus/app/data/models/remote/alert/alerts_response.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_collection.dart';
import 'package:retrofit/retrofit.dart';

part 'alert_provider.g.dart';

@RestApi()
abstract class AlertProvider {
  factory AlertProvider(Dio dio, {String baseUrl}) = _AlertProvider;

  @GET('/alerts')
  Future<AlertsResponse> getAlerts({
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 10,
    @Query('status') String? status,
  });

  @GET('/alerts/{id}')
  Future<AlertResponse> getAlertById(@Path('id') String id);

  @POST('/alerts')
  Future<AlertResponse> createAlert(@Body() AlertRequest request);

  @PATCH('/alerts/{id}')
  Future<AlertResponse> updateAlert(
    @Path('id') String id,
    @Body() AlertRequest request,
  );

  @DELETE('/alerts/{id}')
  Future<HttpResponse> deleteAlert(@Path('id') String id);

  @PATCH('/alerts/{id}/view')
  Future<HttpResponse> markAsViewed(@Path('id') String id);

  @GET('/alerts/{id}/matches')
  Future<BienImmobilierCollection> getAlertMatches({
    @Path('id') required String id,
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 10,
  });
}
