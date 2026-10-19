import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_response.dart';
import 'package:immoplus/app/data/models/remote/search_filters/scope_search_response.dart';
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

  // ─── Recherche scopée (ONG.MD §2–§5) ───────────────────────────────────────

  /// Recherche unifiée par scope. Extrait les `params` des filtres sélectionnés,
  /// les fusionne avec la position GPS et la pagination, puis appelle
  /// l'endpoint correspondant. Retourne une liste plate `ScopeSearchResponse`.
  ///
  /// Voir ONG.MD §4 : « Quand l'utilisateur choisit une option, le front-end
  /// extrait l'objet "params" de l'option choisie et le fusionne directement
  /// dans la requête de l'étape suivante. »
  Future<ScopeSearchResponse> searchScope({
    required HomeFeedScope scope,
    String? cursor,
    int limit = 20,
    Map<String, SearchFilterOption?> selectedFilters = const {},
    double? lat,
    double? lng,
    int? radius,
    // Paramètres spécifiques au séjour
    String? checkIn,
    String? checkOut,
    int? guests,
  }) async {
    try {
      // Résoudre la position GPS (priorité au filtre manuel, sinon GPS)
      final position = await _resolvePosition();
      final resolvedLat = lat ?? position?.$1;
      final resolvedLng = lng ?? position?.$2;

      // Fusionner tels quels les params de tous les filtres sélectionnés
      // (ONG.MD §3–§4). Cela évite de figer côté app la liste des critères
      // pris en charge par le serveur.
      final queryParameters = <String, dynamic>{};
      for (final entry in selectedFilters.entries) {
        final option = entry.value;
        if (option != null) {
          queryParameters.addAll(option.params);
        }
      }

      // Les valeurs explicites de l'écran prévalent sur un filtre éventuel.
      // Les dates et voyageurs choisis via les filtres restent dans la map
      // lorsqu'aucune valeur dédiée n'est fournie.
      queryParameters.addAll({
        'limit': limit,
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        if (resolvedLat != null) 'lat': resolvedLat,
        if (resolvedLng != null) 'lng': resolvedLng,
        if (radius != null) 'radius': radius,
        if (checkIn != null) 'check_in': checkIn,
        if (checkOut != null) 'check_out': checkOut,
        if (guests != null) 'guests': guests,
      });
      queryParameters.removeWhere((_, value) => value == null);

      final response = await _dioClient.get<dynamic>(
        '/me/${scope.value}',
        queryParameters: queryParameters,
      );
      final payload = response.data;
      if (payload is! Map) {
        throw const FormatException('Réponse de recherche invalide');
      }
      return ScopeSearchResponse.fromJson(
        Map<String, dynamic>.from(payload),
      );
    } on DioException catch (dioError) {
      log('DioError when searching /me/${scope.value}: ${dioError.message}');
      throw Exception('Failed to search ${scope.value}: ${dioError.message}');
    } catch (error) {
      log('Error when searching /me/${scope.value}: $error');
      throw Exception('Failed to search ${scope.value}: $error');
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
