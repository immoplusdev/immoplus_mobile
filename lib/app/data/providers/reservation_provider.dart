import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../models/remote/reservations/failure_reasons/motif_echec_reponse_model.dart';
import '../models/remote/reservations/failure_reasons/motifs_echec_response.dart';
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
      @Query("_order_dir") String? orderDir,
      [@Query('_where') List<String>? where]);

  @POST("/v2/reservations")
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

  @POST("/reservations/action/annuler-client/{id}")
  Future<ReservationResponse> annulerReservationClient(
    @Path() String id,
    @Body() Map<String, dynamic> body,
  );

  @POST("/reservations/{id}/action/generer-qr-checkin")
  Future<HttpResponse> generateQrCheckin(@Path() String id);

  /// 1. Liste des motifs d'échec proposés selon le statut et l'acteur
  @GET("/reservations/{id}/motifs-echec")
  Future<MotifsEchecResponse> getMotifsEchec(@Path() String id);

  /// 2. Soumettre le motif d'échec
  @POST("/reservations/{id}/motifs-echec")
  Future<MotifEchecReponseModel> submitMotifEchec(
    @Path() String id,
    @Body() Map<String, dynamic> body,
  );

  /// 3. Consulter la réponse au motif d'échec déjà renseigné
  @GET("/reservations/{id}/motifs-echec/reponse")
  Future<MotifEchecReponseModel> getMotifEchecReponse(@Path() String id);
}
