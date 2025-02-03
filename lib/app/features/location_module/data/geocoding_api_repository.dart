import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/features/location_module/data/dio_client_exception.dart';

import 'geocoding_api_provider.dart';
import 'model/reverse_geocoding_response.dart';

class GeocodingApiRepository {
  /// Reverse geocoding (address lookup)
  final dio = getIt<Dio>();

  Future<ReverseGeocodingResponse> geocodingAddressLookup(
      {double? latitude, double? longitude}) async {
    try {
      final response = await GeocodingApiProvider(dio).geocodingAddressLookup(
        key: dotenv.env['GOOGLE_API_KEY']!,
        latlng: (latitude != null && longitude != null)
            ? [latitude, longitude].join(",")
            : null,
      );
      return response;
    } on DioException catch (dioException) {
      throw DioClientException(dioException);
    }
  }

  /// Geocoding (latitude/longitude lookup)
  Future<ReverseGeocodingResponse> geocodingLatLngLookup(
      {String? placeId}) async {
    try {
      final response = await GeocodingApiProvider(dio).geocodingLatLngLookup(
        key: dotenv.env['GOOGLE_API_KEY']!,
        placeId: placeId,
      );
      return response;
    } on DioException catch (dioException) {
      throw DioClientException(dioException);
    }
  }
}
