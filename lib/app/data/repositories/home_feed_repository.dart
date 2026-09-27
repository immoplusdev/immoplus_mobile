import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_response.dart';
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

  Future<HomeFeedData> getHomeFeed({String? cursor, int limit = 10}) async {
    try {
      final position = await _resolvePosition();
      final deviceId = await _deviceIdService.getDeviceId();
      final response = await HomeFeedProvider(_dioClient).getHomeFeed(
        lat: position?.$1,
        lng: position?.$2,
        cursor: cursor,
        limit: limit,
        deviceId: deviceId,
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
