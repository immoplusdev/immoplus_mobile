import 'package:dio/dio.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:retrofit/retrofit.dart';

import 'model/autocomplete_response.dart';

part 'places_api_provider.g.dart';

@RestApi(baseUrl: null)
abstract class PlacesApiProvider {
  factory PlacesApiProvider(Dio dio, {String baseUrl}) = _PlacesApiProvider;

  /// Get Place Details (New)
  @GET("https://places.googleapis.com/v1/places/{placeId}")
  Future<PlaceDetails> getPlaceDetails({
    @Path("placeId") required String placeId,
    @Query("key") required String key,
    @Query("fields") String? fields = "location",
  });

  @GET("https://maps.googleapis.com/maps/api/place/autocomplete/json")
  Future<AutocompleteResponse> getPlaceAutocomplete({
    @Query("input") String? input,
    @Query("key") required String key,
    @Query("language") String? language = "fr",
    @Query("region") String? region = "ci",
    @Query("sessiontoken") String? sessiontoken,
    @Query("components") String? components = "country:ci",
  });
}
