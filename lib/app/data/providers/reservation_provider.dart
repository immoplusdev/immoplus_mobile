import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../models/remote/reservations/reservation_request_body.dart';
import '../models/remote/reservations/reservation_response.dart';
import '../models/remote/reservations/reservations_collection.dart';

part 'reservation_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class ReservationProvider {
  factory ReservationProvider(Dio dio, {String baseUrl}) = _ReservationProvider;

  //@GET("https://api.npoint.io/d9bca4bd7f02db43cbde")
  @GET("/reservations/{id}")
  Future<ReservationResponse> getBooking(@Path() String id);

  //@GET("https://api.npoint.io/5298d4a42fc8b74cf43e")
  @GET("/reservations")
  Future<ReservationsCollection> getBookings(
      @Query("_search") String? search,
      @Query("_page") int page,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @POST("/reservations")
  Future<ReservationResponse> createBookings(
      @Body() ReservationRequestBody body);

  @GET("/reservations/data/residence/owner/{id}")
  Future<ReservationsCollection> getBookingsOwner(
      @Query("_search") String? search,
      @Path() String id,
      @Query("_page") int page,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @POST("/reservations/action/annuler/{id}")
  Future<ReservationResponse> annulerBookings(@Path() String id);
}
