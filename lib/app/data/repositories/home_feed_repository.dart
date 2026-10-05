import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_response.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/data/providers/home_feed_provider.dart';
import 'package:immoplus/app/services/device_id_service.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeFeedRepository {
  final Dio _dioClient;
  final DeviceIdService _deviceIdService;

  HomeFeedRepository(this._dioClient, this._deviceIdService);

  Future<HomeFeedData> getHomeFeed({
    String? cursor,
    int limit = 10,
    String? villeId,
    String? sections,
    int? items,
  }) async {
    try {
      final position = await _resolvePosition();
      final deviceId = await _deviceIdService.getDeviceId();
      final response = await HomeFeedProvider(_dioClient).getHomeFeed(
        lat: position?.$1,
        lng: position?.$2,
        cursor: cursor,
        limit: limit,
        deviceId: deviceId,
        villeId: villeId,
        sections: sections,
        items: items,
      );
      return response.data;
    } on DioException catch (dioError) {
      log('DioError when loading /me/home: ${dioError.message}');
      throw Exception('Failed to load home feed: ${dioError.message}');
    } catch (error) {
      log('Error when loading /me/home: $error');
      throw Exception('Failed to load home feed: $error');
    }
  }

  Future<HomeFeedData> getRentFeed({
    String? cursor,
    int limit = 10,
    String? villeId,
    String? sections,
    int? items,
  }) async {
    try {
      final position = await _resolvePosition();
      final deviceId = await _deviceIdService.getDeviceId();
      final response = await HomeFeedProvider(_dioClient).getRentFeed(
        cursor: cursor,
        limit: limit,
        lat: position?.$1,
        lng: position?.$2,
        villeId: villeId,
        deviceId: deviceId,
        sections: sections,
        items: items,
      );
      return response.data;
    } on DioException catch (dioError) {
      log('DioError when loading /me/rent: ${dioError.message}');
      throw Exception('Failed to load rent feed: ${dioError.message}');
    } catch (error) {
      log('Error when loading /me/rent: $error');
      throw Exception('Failed to load rent feed: $error');
    }
  }

  Future<HomeFeedData> getBuyFeed({
    String? cursor,
    int limit = 10,
    String? villeId,
    String? sections,
    int? items,
  }) async {
    try {
      final position = await _resolvePosition();
      final deviceId = await _deviceIdService.getDeviceId();
      final response = await HomeFeedProvider(_dioClient).getBuyFeed(
        cursor: cursor,
        limit: limit,
        lat: position?.$1,
        lng: position?.$2,
        villeId: villeId,
        deviceId: deviceId,
        sections: sections,
        items: items,
      );
      return response.data;
    } on DioException catch (dioError) {
      log('DioError when loading /me/buy: ${dioError.message}');
      throw Exception('Failed to load buy feed: ${dioError.message}');
    } catch (error) {
      log('Error when loading /me/buy: $error');
      throw Exception('Failed to load buy feed: $error');
    }
  }

  Future<HomeFeedData> getStayFeed({
    String? cursor,
    int limit = 10,
    String? villeId,
    String? sections,
    int? items,
  }) async {
    try {
      final position = await _resolvePosition();
      final deviceId = await _deviceIdService.getDeviceId();
      final response = await HomeFeedProvider(_dioClient).getStayFeed(
        cursor: cursor,
        limit: limit,
        lat: position?.$1,
        lng: position?.$2,
        villeId: villeId,
        deviceId: deviceId,
        sections: sections,
        items: items,
      );
      return response.data;
    } on DioException catch (dioError) {
      log('DioError when loading /me/stay: ${dioError.message}');
      throw Exception('Failed to load stay feed: ${dioError.message}');
    } catch (error) {
      log('Error when loading /me/stay: $error');
      throw Exception('Failed to load stay feed: $error');
    }
  }

  /// Récupère la structure des filtres pour l'onglet spécifié ('rent', 'buy', 'stay')
  Future<SearchFiltersData> getSearchFilters({required String scope}) async {
    try {
      final response =
          await HomeFeedProvider(_dioClient).getSearchFilters(scope: scope);
      return response.data;
    } on DioException catch (dioError) {
      log('DioError when loading /me/search/filters ($scope): ${dioError.message}');
      throw Exception('Failed to load search filters: ${dioError.message}');
    } catch (error) {
      log('Error when loading /me/search/filters ($scope): $error');
      throw Exception('Failed to load search filters: $error');
    }
  }

  /// Réutilise la même logique que `ResidencesNearList` : priorité à la
  /// position choisie manuellement (`FilterHandler`), fallback GPS. Échoue
  /// silencieusement — sans lat/long, le backend omet simplement `near_you`.
  Future<(double, double)?> _resolvePosition() async {
    if (FilterHandler.lat != null && FilterHandler.long != null) {
      return (FilterHandler.lat!, FilterHandler.long!);
    }
    try {
      final position = await LocationService.getCurrentPosition();
      return (position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }
}
