import 'package:dio/dio.dart' hide Headers;

import 'package:retrofit/retrofit.dart';

import '../models/remote/bienimmobilier/bien_immobilier_collection.dart';
import '../models/remote/bienimmobilier/bien_immobilier_creation_model.dart';
import '../models/remote/bienimmobilier/bien_immobilier_single.dart';
import '../models/remote/bienimmobilier/demande_visit_request_body.dart';
import '../models/remote/bienimmobilier/demande_visit_response.dart';
import '../models/remote/bienimmobilier/demande_visite_body_model.dart';
import '../models/remote/bienimmobilier/demande_visite_collection.dart';
import '../models/remote/bienimmobilier/demande_visite_model.dart';
import '../models/remote/bienimmobilier/visit_programmer_body.dart';
import '../models/remote/residence/residence_creation_model.dart';
import '../models/remote/residence/residence_response.dart';

part 'bien_immobilier_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class BienImmobilierProvider {
  factory BienImmobilierProvider(Dio dio, {String baseUrl}) =
      _BienImmobilierProvider;

  //@GET("https://www.npoint.io/docs/5af09fdcad3bdbbbc610")
  @GET("/biens-immobiliers/{id}")
  Future<BienImmobilierSingle> getImmobilier(@Path() String id);

  @GET("/biens-immobiliers/data/filter/public")
  Future<BienImmobilierCollection> getImmobiliers({
    @Query("_search") String? search,
    @Queries() Map<String, dynamic>? where,
    @Query("_lat") double? lat,
    @Query("_long") double? long,
    @Query("_per_page") int? perPage,
    @Query("_page") int? page,
    @Query("_radius") double? radius,
    @Query("_start_date") String? startDate,
    @Query("_end_date") String? endDate,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  });
  @GET("/biens-immobiliers/data/public/proprietaire/{proprietaireId}")
  Future<BienImmobilierCollection> getImmobiliersProprietaireId({
    @Path() required String proprietaireId,
    @Query("_search") String? search,
    @Queries() Map<String, dynamic>? where,
    @Query("_lat") double? lat,
    @Query("_long") double? long,
    @Query("_per_page") int? perPage,
    @Query("_page") int? page,
    @Query("_radius") double? radius,
    @Query("_start_date") String? startDate,
    @Query("_end_date") String? endDate,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  });
  //* end point de la map
  @GET("/biens-immobiliers/data/public/geolocalized")
  Future<BienImmobilierCollection> getBienImmobilierGeolocalized(
      {@Query("_lat") double? lat,
      @Query("_long") double? long,
      @Query("_radius") double? radius,
      @Query("_per_page") int? perPage,
      @Query("_page") int? page,
      @Query("_search") String? search,
      @Query('_where') List<Map<String, dynamic>>? where,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir});

  @POST("/biens-immobiliers")
  Future<BienImmobilierSingle> createBienImmobilier(
      @Body() BienImmobilierCreationModel bienImmobilier);

  @PATCH("/biens-immobiliers")
  Future<ResidenceResponse> update(
      @Body() ResidenceCreationModel bienImmobilier);

  //VISITE
  @GET("/demandes-visites/{id}")
  Future<DemandeVisitResponse> getVisite(@Path() String id);

  @POST("/demandes-visites")
  Future<DemandeVisitResponse> createVisite(
      @Body() DemandeVisitRequestBody body);

  @GET("https://api.npoint.io/2d556cc695c18d99dd84")
  //@GET("/demandes-visites/data/bien-immobilier/owner/{id}")
  Future<DemandeVisiteCollection> getVisiteOwner(
      @Query("_search") String? search,
      @Path() String id,
      @Query("_page") int page,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @GET("/demandes-visites")
  Future<DemandeVisiteCollection> getVisites(
      @Query("_search") String? search,
      @Query("_page") int page,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  // @POST("/demandes-visites")
  // Future<DemandeVisiteModel> createVisite(
  //     @Body() DemandeVisiteBodyModel demandes);

  @PATCH("/demandes-visites")
  Future<DemandeVisiteModel> updateVisite(
      @Body() DemandeVisiteBodyModel demandes);

  @POST("/demandes-visites/action/programmer/{id}")
  Future<DemandeVisiteModel> programmer(@Body() VisitProgrammerBody programmer);
}
