import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:immoplus/app/core/config/injection.dart';

import 'dio_client_exception.dart';
import 'model/autocomplete_response.dart';
import 'places_api_provider.dart';

class PlacesApiRepository {
  /// Get Place Details (New)
  final dio = getIt<Dio>();

  Future<PlaceDetails> getPlaceDetails({required String placeId}) async {
    try {
      final response = await PlacesApiProvider(dio).getPlaceDetails(
        key: dotenv.env['GOOGLE_API_KEY']!,
        placeId: placeId,
      );
      return response;
    } on DioException catch (dioException) {
      throw DioClientException(dioException);
    }
  }

  Future<AutocompleteResponse> getPlaceAutocomplete(
      {required String input, String? sessionToken}) async {
    try {
      final response = await PlacesApiProvider(dio).getPlaceAutocomplete(
          input: input,
          key: dotenv.env['GOOGLE_API_KEY']!,
          sessiontoken: sessionToken);
      return compute(_parsePlacesAutocompleteResponse, response);
    } on DioException catch (dioException) {
      throw DioClientException(dioException);
    }
  }

  AutocompleteResponse _parsePlacesAutocompleteResponse(
      AutocompleteResponse data) {
    data.predictions?.forEach((element) => element.reference = null);
    return data;
  }
}
