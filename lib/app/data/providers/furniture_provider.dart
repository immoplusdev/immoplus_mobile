import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../models/remote/furniture/furniture_collection.dart';
import '../models/remote/furniture/furniture_response.dart';

part 'furniture_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class FurnitureProvider {
  factory FurnitureProvider(Dio dio, {String baseUrl}) = _FurnitureProvider;

  @GET("/furnitures/{id}")
  Future<FurnitureResponse> getFurniture(@Path() String id);

  @GET("/furnitures")
  Future<FurnitureCollection> getFurnitures({
    @Query("_search") String? search,
    @Queries() Map<String, dynamic>? where,
    @Query("lat") double? lat,
    @Query("long") double? long,
    @Query("_per_page") int? perPage,
    @Query("_page") int? page,
    @Query("radius") double? radius,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  });

  @GET("/furnitures/proprietaire/{proprietaireId}")
  Future<FurnitureCollection> getFurnituresProprietaire({
    @Path() required String proprietaireId,
    @Query("_search") String? search,
    @Queries() Map<String, dynamic>? where,
    @Query("lat") double? lat,
    @Query("long") double? long,
    @Query("_per_page") int? perPage,
    @Query("_page") int? page,
    @Query("radius") double? radius,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  });

  @GET("/furnitures/geolocalized")
  Future<FurnitureCollection> getFurnituresGeolocalized({
    @Query("lat") double? lat,
    @Query("long") double? long,
    @Query("radius") double? radius,
    @Query("_per_page") int? perPage,
    @Query("_page") int? page,
    @Query("_search") String? search,
    @Query('_where') List<Map<String, dynamic>>? where,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  });
}

