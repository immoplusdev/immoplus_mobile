import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_list_item.dart';

/// Résultat complet d'une page chargée depuis `seeMoreEndpoint`.
class SeeMoreResult {
  final List<HomeFeedListItem> items;
  final bool hasNext;
  final bool hasPrevious;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;

  const SeeMoreResult({
    required this.items,
    this.hasNext = false,
    this.hasPrevious = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalCount = 0,
    this.pageSize = 10,
  });
}

/// Helper pour récupérer et mapper les éléments paginés depuis `seeMoreEndpoint`.
class SeeMoreFetcher {
  static Future<SeeMoreResult> fetch({
    required String seeMoreEndpoint,
    required int page,
    required int limit,
    required bool isResidence,
    Dio? dioClient,
  }) async {
    try {
      final client = dioClient ?? getIt<Dio>();
      final uri = Uri.parse(seeMoreEndpoint);
      final query = Map<String, dynamic>.from(uri.queryParameters);

      // Si l'URL originale utilise déjà des paramètres avec underscore, on garde la même convention
      if (query.containsKey('_page') ||
          query.containsKey('_per_page') ||
          query.containsKey('_limit')) {
        query['_page'] = '$page';
        if (limit > 0) {
          if (query.containsKey('_per_page')) {
            query['_per_page'] = '$limit';
          } else {
            query['_limit'] = '$limit';
          }
        }
      } else {
        query['page'] = '$page';
        if (limit > 0) {
          query['limit'] = '$limit';
        }
      }

      final finalUrl = uri.replace(queryParameters: query).toString();
      final response = await client.get(finalUrl);
      final rawData = response.data;

      final items = parseItems(rawData, isResidence: isResidence);

      if (rawData is Map) {
        final hasNext = rawData['hasNext'] as bool? ??
            (rawData['currentPage'] != null &&
                rawData['totalPages'] != null &&
                (rawData['currentPage'] as num) <
                    (rawData['totalPages'] as num));

        return SeeMoreResult(
          items: items,
          hasNext: hasNext,
          hasPrevious: rawData['hasPrevious'] as bool? ?? false,
          currentPage: (rawData['currentPage'] as num?)?.toInt() ?? page,
          totalPages: (rawData['totalPages'] as num?)?.toInt() ?? 1,
          totalCount: (rawData['totalCount'] as num?)?.toInt() ?? items.length,
          pageSize: (rawData['pageSize'] as num?)?.toInt() ?? limit,
        );
      }

      return SeeMoreResult(
        items: items,
        hasNext: items.length >= limit,
        currentPage: page,
        pageSize: limit,
      );
    } catch (_) {
      return const SeeMoreResult(items: []);
    }
  }

  static List<HomeFeedListItem> parseItems(
    dynamic rawData, {
    required bool isResidence,
  }) {
    final List<dynamic> list;
    if (rawData is List) {
      list = rawData;
    } else if (rawData is Map && rawData['data'] is List) {
      list = rawData['data'] as List;
    } else {
      return [];
    }

    return list
        .map((raw) {
          if (raw is! Map<String, dynamic>) {
            if (raw is Map) {
              raw = Map<String, dynamic>.from(raw);
            } else {
              return null;
            }
          }

          if (isResidence) {
            final images = raw['images'] as List?;
            final firstImage = (images != null && images.isNotEmpty)
                ? images.first.toString()
                : null;

            final residenceMap = <String, dynamic>{
              'residenceId': raw['residenceId'] ?? raw['id'] ?? '',
              'name': raw['name'] ?? raw['nom'] ?? '',
              'location': raw['location'] ??
                  raw['commune'] ??
                  raw['ville'] ??
                  raw['adresse'],
              'imageUrl': raw['imageUrl'] ?? raw['miniature'] ?? firstImage,
              'pricePerNight':
                  raw['pricePerNight'] ?? raw['prixReservation'] ?? raw['prix'],
              'currency': raw['currency'] ?? 'XOF',
              'description': raw['description'],
              if (raw['chips'] != null) 'chips': raw['chips'],
              if (raw['badge'] != null) 'badge': raw['badge'],
              if (raw['averageRating'] != null)
                'averageRating': raw['averageRating'],
              if (raw['totalReviews'] != null)
                'totalReviews': raw['totalReviews'],
            };
            return HomeFeedListItem(
              itemType: 'item',
              item: residenceMap,
            );
          } else {
            final images = raw['images'] as List?;
            final firstImage = (images != null && images.isNotEmpty)
                ? images.first.toString()
                : null;

            final bienMap = <String, dynamic>{
              'bienId': raw['bienId'] ?? raw['id'] ?? '',
              'name': raw['name'] ?? raw['nom'] ?? '',
              'location': raw['location'] ??
                  raw['commune'] ??
                  raw['ville'] ??
                  raw['adresse'],
              'imageUrl': raw['imageUrl'] ?? raw['miniatureId'] ?? firstImage,
              'price': raw['price'] ?? raw['prix'],
              'currency': raw['currency'] ?? 'XOF',
              'aLouer': raw['aLouer'] ?? false,
              'typeLocation': raw['typeLocation'],
              'typeBienImmobilier': raw['typeBienImmobilier'],
              'description': raw['description'],
              if (raw['chips'] != null) 'chips': raw['chips'],
              if (raw['badge'] != null) 'badge': raw['badge'],
            };
            return HomeFeedListItem(
              itemType: 'item',
              item: bienMap,
            );
          }
        })
        .whereType<HomeFeedListItem>()
        .toList();
  }
}
