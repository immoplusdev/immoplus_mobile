import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../models/remote/residence/residence_creation_model.dart';
import '../models/remote/residence/residence_response.dart';
import '../models/remote/residence/residences_collection.dart';

part 'residence_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class ResidenceProvider {
  factory ResidenceProvider(Dio dio, {String baseUrl}) = _ResidenceProvider;

  //@GET("https://www.npoint.io/docs/5af09fdcad3bdbbbc610")
  @GET("/residences/data/public/{id}")
  Future<ResidenceResponse> getResidence(@Path() String id);

  @GET("/residences/data/filter/public")
  Future<ResidencesCollection> getResidences({
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

  @GET("/residences/data/search/public")
  Future<ResidencesCollection> searchResidencesPublic({
    @Query("zones") String? zones,
    @Query("priceMin") int? priceMin,
    @Query("priceMax") int? priceMax,
    @Query("occupantsMin") int? occupantsMin,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
    @Query("page") int? page,
    @Query("perPage") int? perPage,
  });

  @GET("/residences/data/public/proprietaire/{proprietaireId}")
  Future<ResidencesCollection> getResidencesProprietaire({
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
  @GET("/residences/data/public/geolocalized")
  Future<ResidencesCollection> getResidencesGeolocalized(
      {@Query("_lat") double? lat,
      @Query("_long") double? long,
      @Query("_radius") double? radius,
      @Query("_per_page") int? perPage,
      @Query("_page") int? page,
      @Query("_search") String? search,
      @Query('_where') List<Map<String, dynamic>>? where,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir});

  @POST("/residences")
  Future<ResidenceResponse> createResidence(
      @Body() ResidenceCreationModel residenceCreationModel);

  @PATCH("/residences/{id}")
  Future<ResidenceResponse> update(
      @Path() String id, @Body() Map<String, dynamic> data);
}
