import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/search_filters/scope_search_response.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/data/repositories/home_feed_repository.dart';
import 'package:immoplus/app/services/device_id_service.dart';
import 'package:immoplus/app/utils/filter_handler.dart';

void main() {
  group('ScopeSearchItem', () {
    test('garde les filtres stay lorsque certaines options n’ont pas de label',
        () {
      final response = SearchFiltersResponse.fromJson(const {
        'data': {
          'scope': 'stay',
          'filters': [
            {
              'key': 'type',
              'kind': 'select',
              'label': 'Type de bien',
              'options': [
                {
                  'value': 'maison',
                  'label': 'Maison',
                  'params': {'type': 'maison'},
                },
                {
                  'value': 'triplex',
                  'params': {'type': 'triplex'},
                },
              ],
            },
          ],
        },
      });

      expect(response.data.scope, 'stay');
      expect(response.data.filters, hasLength(1));
      expect(response.data.filters.single.options, hasLength(2));
      expect(response.data.filters.single.options.last.label, isEmpty);
    });

    test('lit l’enveloppe sections et sa pagination par curseur', () {
      final response = ScopeSearchResponse.fromJson(const {
        'data': {
          'sections': [
            {
              'key': 'rent_results',
              'title': 'Logements à louer près de vous',
              'totalCount': 42,
              'items': [
                {
                  'item': {'bienId': 'rent-1', 'name': 'Appartement Cocody'}
                }
              ],
            }
          ],
          'hasMore': true,
          'nextCursor': 'next-batch',
        },
      });

      expect(response.data.single.bienId, 'rent-1');
      expect(
          response.data.single.sectionTitle, 'Logements à louer près de vous');
      expect(response.totalCount, 42);
      expect(response.hasMore, isTrue);
      expect(response.nextCursor, 'next-batch');
    });

    test('lit le format léger documenté dans ONG.MD', () {
      final item = ScopeSearchItem.fromJson(const {
        'bienId': 'new-id',
        'name': 'Villa Cocody',
        'imageUrl': 'image-id',
        'price': 185000000,
        'currency': 'XOF',
      });

      expect(item.bienId, 'new-id');
      expect(item.imageUrl, 'image-id');
      expect(item.price, 185000000);
    });

    test('lit le format historique avec images et prix français', () {
      final item = ScopeSearchItem.fromJson(const {
        'item': {
          'id': 'old-id',
          'nom': 'Résidence Marcory',
          'images': [
            'https://cdn.example.test/residence.jpg',
          ],
          'prixReservation': '45000',
          'devise': 'XOF',
          'ville': 'Marcory',
        },
      });

      expect(item.bienId, 'old-id');
      expect(item.name, 'Résidence Marcory');
      expect(item.imageUrl, 'https://cdn.example.test/residence.jpg');
      expect(item.price, 45000);
      expect(item.currency, 'XOF');
      expect(item.location, 'Marcory');
    });
  });

  group('HomeFeedRepository.searchScope', () {
    late double? previousLat;
    late double? previousLng;

    setUp(() {
      previousLat = FilterHandler.lat;
      previousLng = FilterHandler.long;
      // Évite une requête de géolocalisation native pendant le test.
      FilterHandler.lat = 5.36;
      FilterHandler.long = -3.98;
    });

    tearDown(() {
      FilterHandler.lat = previousLat;
      FilterHandler.long = previousLng;
    });

    test('utilise /me/buy et fusionne les paramètres dynamiques', () async {
      final request = <String, dynamic>{};
      final repository = HomeFeedRepository(
        _dioRecording(request),
        DeviceIdService(),
      );

      await repository.searchScope(
        scope: HomeFeedScope.buy,
        cursor: 'cursor-for-next-batch',
        limit: 10,
        selectedFilters: {
          'type': const SearchFilterOption(
            value: 'villa',
            label: 'Villa',
            params: {'type': 'villa'},
          ),
          'budget': const SearchFilterOption(
            value: '50-100',
            label: '50 à 100 M',
            params: {'min_price': 50000000, 'max_price_lt': 100000000},
          ),
        },
      );

      expect(request['path'], '/me/buy');
      expect(request['query'], {
        'type': 'villa',
        'min_price': 50000000,
        'max_price_lt': 100000000,
        'limit': 10,
        'cursor': 'cursor-for-next-batch',
        'lat': 5.36,
        'lng': -3.98,
      });
    });

    test('utilise /me/stay avec les dates et le nombre de voyageurs', () async {
      final request = <String, dynamic>{};
      final repository = HomeFeedRepository(
        _dioRecording(request),
        DeviceIdService(),
      );

      await repository.searchScope(
        scope: HomeFeedScope.stay,
        selectedFilters: {
          'dates': const SearchFilterOption(
            value: 'range',
            label: '8–15 juin',
            params: {
              'check_in': '2026-06-08',
              'check_out': '2026-06-15',
            },
          ),
          'guests': const SearchFilterOption(
            value: 2,
            label: '2 voyageurs',
            params: {'guests': 2},
          ),
        },
      );

      expect(request['path'], '/me/stay');
      expect(request['query']['check_in'], '2026-06-08');
      expect(request['query']['check_out'], '2026-06-15');
      expect(request['query']['guests'], 2);
      expect(request['query']['limit'], 20);
    });
  });
}

Dio _dioRecording(Map<String, dynamic> request) {
  return Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request['path'] = options.path;
          request['query'] = Map<String, dynamic>.from(options.queryParameters);
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'data': {
                  'sections': [],
                  'count': 0,
                  'hasMore': false,
                  'nextCursor': null,
                },
              },
            ),
          );
        },
      ),
    );
}
