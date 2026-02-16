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
    @Query("search") String? search,
    @Queries() Map<String, dynamic>? where,
    @Query("lat") double? lat,
    @Query("long") double? long,
    @Query("perPage") int? perPage,
    @Query("page") int? page,
    @Query("radius") double? radius,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
    @Query("orderBy") String? orderBy,
    @Query("orderDir") String? orderDir,
  });

  @GET("/furnitures/proprietaire/{proprietaireId}")
  Future<FurnitureCollection> getFurnituresProprietaire({
    @Path() required String proprietaireId,
    @Query("search") String? search,
    @Queries() Map<String, dynamic>? where,
    @Query("lat") double? lat,
    @Query("long") double? long,
    @Query("perPage") int? perPage,
    @Query("page") int? page,
    @Query("radius") double? radius,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
    @Query("orderBy") String? orderBy,
    @Query("orderDir") String? orderDir,
  });

  @GET("/furnitures/geolocalized")
  Future<FurnitureCollection> getFurnituresGeolocalized({
    @Query("lat") double? lat,
    @Query("long") double? long,
    @Query("radius") double? radius,
    @Query("perPage") int? perPage,
    @Query("page") int? page,
    @Query("search") String? search,
    @Query('where') List<Map<String, dynamic>>? where,
    @Query("orderBy") String? orderBy,
    @Query("orderDir") String? orderDir,
  });
}

