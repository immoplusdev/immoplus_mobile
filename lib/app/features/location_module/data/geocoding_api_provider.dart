import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'model/reverse_geocoding_response.dart';
part 'geocoding_api_provider.g.dart';

@RestApi(baseUrl: null)
abstract class GeocodingApiProvider {
  factory GeocodingApiProvider(Dio dio, {String baseUrl}) =
      _GeocodingApiProvider;

  /// Reverse geocoding (address lookup)
  @GET("https://maps.googleapis.com/maps/api/geocode/json")
  Future<ReverseGeocodingResponse> geocodingAddressLookup({
    @Query("key") required String key,
    @Query("language") String? language = "fr",
    @Query("region") String? region = "ci",
    @Query("latlng") String? latlng,
  });

  /// Geocoding (latitude/longitude lookup)
  @GET("https://maps.googleapis.com/maps/api/geocode/json")
  Future<ReverseGeocodingResponse> geocodingLatLngLookup({
    @Query("key") required String key,
    @Query("language") String? language = "fr",
    @Query("region") String? region = "ci",
    @Query("place_id") String? placeId,
    @Query("latlng") String? latlng,
  });
}
