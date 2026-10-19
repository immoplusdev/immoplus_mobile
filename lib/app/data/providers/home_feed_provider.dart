import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../models/remote/home_feed/home_feed_response.dart';
import '../models/remote/search_filters/search_filters_response.dart';

part 'home_feed_provider.g.dart';

@RestApi(baseUrl: null)
abstract class HomeFeedProvider {
  factory HomeFeedProvider(Dio dio, {String baseUrl}) = _HomeFeedProvider;

  @GET("/me/home")
  Future<HomeFeedApiResponse> getHomeFeed({
    @Query("lat") double? lat,
    @Query("lng") double? lng,
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("device_id") String? deviceId,
    @Query("villeId") String? villeId,
    @Query("sections") String? sections,
    @Query("items") int? items,
  });

  /// Trouver un logement : biens et terrains à louer
  @GET("/me/rent")
  Future<HomeFeedApiResponse> getRentFeed({
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("lat") double? lat,
    @Query("lng") double? lng,
    @Query("villeId") String? villeId,
    @Query("device_id") String? deviceId,
    @Query("sections") String? sections,
    @Query("items") int? items,
  });

  /// Acheter un bien : biens et terrains à vendre
  @GET("/me/buy")
  Future<HomeFeedApiResponse> getBuyFeed({
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("lat") double? lat,
    @Query("lng") double? lng,
    @Query("villeId") String? villeId,
    @Query("device_id") String? deviceId,
    @Query("sections") String? sections,
    @Query("items") int? items,
  });

  /// Trouver un séjour : résidences, disponibilités et nouveautés
  @GET("/me/stay")
  Future<HomeFeedApiResponse> getStayFeed({
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("lat") double? lat,
    @Query("lng") double? lng,
    @Query("villeId") String? villeId,
    @Query("device_id") String? deviceId,
    @Query("sections") String? sections,
    @Query("items") int? items,
  });

  /// Récupère la description des filtres pour un onglet (rent, buy, stay)
  @GET("/me/search/filters")
  Future<SearchFiltersResponse> getSearchFilters({
    @Query("scope") required String scope,
  });
}
