import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'client_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class ClientProvider {
  factory ClientProvider(Dio dio, {String baseUrl}) = _ClientProvider;

  /// Mode de réservation du client connecté (`PAY_NOW` ou `REQUEST`).
  @GET("/clients/me/booking-mode")
  Future<dynamic> getBookingMode();
}
