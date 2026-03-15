import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:immoplus/main.dart';

typedef FeedPage = ({List<VideoModel> items, String? cursor, bool hasMore});

class VideoRepository {
  VideoRepository() {
    if (kDebugMode) {
      _dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: false,
            printResponseHeaders: false,
            printRequestData: true,
            printResponseData: true,
            printResponseMessage: true,
          ),
        ),
      );
    }
  }

  final Dio _dio = Dio();
  final CacheManager cacheManager = CacheManager(
    Config(
      'progressiveVideoCache',
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 200,
    ),
  );
  final Set<String> _cachedCacheKeys = <String>{};
  final Set<String> _inFlightCacheKeys = <String>{};

  String get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  static bool _isLocalhostHost(String host) =>
      host == 'localhost' || host == '127.0.0.1' || host == '0.0.0.0';

  static bool _looksLikePresignedUrl(Uri uri) {
    if (!uri.hasQuery) return false;
    for (final key in uri.queryParameters.keys) {
      final lower = key.toLowerCase();
      if (lower.startsWith('x-amz-')) return true; // S3/MinIO
      if (lower.startsWith('x-goog-')) return true; // GCS
    }
    return false;
  }

  /// Clé de cache stable pour une URL (ignore query/fragment).
  /// Utile avec les URLs presignées (signature qui change) pour éviter de
  /// re-télécharger/cacher le même fichier à l'infini.
  static String _cacheKeyForUrl(String url) {
    if (url.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null) return url.split('#').first.split('?').first;
    return uri.replace(query: '', fragment: '').toString();
  }

  // ---------------------------------------------------------------------------
  // Feed API — GET /feed
  // ---------------------------------------------------------------------------

  Future<FeedPage> fetchFeed({String? cursor, int limit = 5}) async {
    final params = <String, dynamic>{'limit': limit};
    if (cursor != null) {
      params['cursor'] = cursor;
    }
    try {
      if (cursor != null) {
        talker.info(
            '[VideoRepository] 📡 GET /feed?limit=$limit (pagination) | '
            'cursor=${cursor.substring(0, 8)}... | TikTok-like incremental load');
      } else {
        talker.info(
            '[VideoRepository] 📡 GET /feed?limit=$limit (initial) | First batch of videos');
      }

      final response = await _dio.get(
        '$_baseUrl/feed',
        queryParameters: params,
      );
      final etag = response.headers.value('etag');
      if (etag != null && etag.trim().isNotEmpty) {
        talker.debug('[VideoRepository] ↩︎ /feed response etag=$etag');
      }
      return _parseFeedPage(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 429) {
        final retryAfterHeader =
            e.response?.headers.value('retry-after')?.trim();
        final retryDelay = Duration(
          milliseconds: int.tryParse(retryAfterHeader ?? '') != null
              ? (int.parse(retryAfterHeader!) * 1000)
              : 800,
        );
        talker.warning(
          '[VideoRepository] ⏳ 429 rate limited on GET /feed; retry in ${retryDelay.inMilliseconds}ms',
        );
        await Future.delayed(retryDelay);
        try {
          final response = await _dio.get(
            '$_baseUrl/feed',
            queryParameters: params,
          );
          return _parseFeedPage(response.data as Map<String, dynamic>);
        } catch (e2) {
          talker.error('[VideoRepository] ❌ fetchFeed retry failed', e2);
        }
      } else {
        talker.error('[VideoRepository] ❌ fetchFeed Dio error', e);
      }
      return (items: <VideoModel>[], cursor: null, hasMore: false);
    } catch (e) {
      talker.error('[VideoRepository] ❌ fetchFeed error', e);
      return (items: <VideoModel>[], cursor: null, hasMore: false);
    }
  }

  Future<VideoModel?> fetchVideoDetail(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/feed/videos/$id');
      final data = (response.data as Map<String, dynamic>)['data'];
      if (data == null) return null;
      return VideoModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[VideoRepository] fetchVideoDetail error → $e');
      return null;
    }
  }

  /// Remplace le scheme+host+port localhost/127.0.0.1 par le vrai domaine API.
  /// Utile quand le backend est déployé mais retourne encore des URLs localhost.
  String _normalizeUrl(String url) {
    if (url.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    // Ne jamais "normaliser" une URL presignée : changer le host casse la
    // signature (et donc le téléchargement).
    if (_looksLikePresignedUrl(uri)) return url;

    if (!_isLocalhostHost(uri.host)) return url;
    return _baseUrl + uri.path + (uri.hasQuery ? '?${uri.query}' : '');
  }

  FeedPage _parseFeedPage(Map<String, dynamic> data) {
    final rawList = data['data'] as List<dynamic>? ?? [];

    final items = <VideoModel>[];
    int filtered = 0;

    for (final e in rawList) {
      final json = Map<String, dynamic>.from(e as Map);
      // Normalise les URLs localhost → domaine API réel
      if (json['videoUrl'] is String) {
        json['videoUrl'] = _normalizeUrl(json['videoUrl'] as String);
      }
      if (json['thumbnailUrl'] is String) {
        json['thumbnailUrl'] = _normalizeUrl(json['thumbnailUrl'] as String);
      }
      final video = VideoModel.fromJson(json);
      // Ne rejeter que les vidéos sans URL
      if (video.url.isEmpty) {
        filtered++;
        talker.debug('[Feed] Filtered video (empty URL): id=${video.id}');
        continue;
      }
      items.add(video);
    }

    final nextCursor = data['cursor'] as String?;
    final hasMore = data['has_more'] as bool? ?? false;

    talker.info(
      '[Feed] ✓ Parsed response | '
      'received=${rawList.length} | valid=${items.length} | filtered=$filtered | '
      'nextCursor=${nextCursor?.substring(0, 8) ?? 'null'}... | hasMore=$hasMore',
    );

    return (
      items: items,
      cursor: nextCursor,
      hasMore: hasMore,
    );
  }

  // ---------------------------------------------------------------------------
  // Cache & thumbnail helpers (inchangés)
  // ---------------------------------------------------------------------------

  Future<void> initializeCacheMetadata(List<VideoModel> videos) async {
    for (final video in videos) {
      final cached = await cacheManager.getFileFromCache(
        _cacheKeyForUrl(video.url),
      );
      if (cached != null && await cached.file.exists()) {
        _cachedCacheKeys.add(_cacheKeyForUrl(video.url));
      }
    }
  }

  bool isStreamManifest(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.m3u8') || lower.contains('.mpd');
  }

  Future<File?> getCachedFile(String url) async {
    final key = _cacheKeyForUrl(url);
    final cached = await cacheManager.getFileFromCache(key);
    if (cached != null && await cached.file.exists()) {
      _cachedCacheKeys.add(key);
      return cached.file;
    }
    _cachedCacheKeys.remove(key);
    return null;
  }

  static const int _thumbMaxHeight = 426;
  static const int _thumbQuality = 85;

  Future<String?> getThumbnailPathForVideo(String videoUrl) async {
    if (isStreamManifest(videoUrl)) return null;
    final dir = await getTemporaryDirectory();
    final thumbDir = Directory('${dir.path}/video_thumbnails');
    if (!await thumbDir.exists()) await thumbDir.create(recursive: true);
    final key = videoUrl.hashCode.abs();
    final ourPath = '${thumbDir.path}/thumb_$key.jpg';
    final file = File(ourPath);
    if (await file.exists()) return ourPath;
    try {
      final path = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: thumbDir.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: _thumbMaxHeight,
        quality: _thumbQuality,
        timeMs: 500,
      );
      if (path == null) return null;
      final createdPath =
          path.startsWith('/') ? path : '${thumbDir.path}/$path';
      final created = File(createdPath);
      if (await created.exists() && createdPath != ourPath) {
        await created.copy(ourPath);
        await created.delete();
      }
      return File(ourPath).existsSync() ? ourPath : null;
    } catch (e) {
      debugPrint('[VideoRepository] thumbnail failed for $videoUrl → $e');
      return null;
    }
  }

  Future<void> cacheInBackground(String url) async {
    if (isStreamManifest(url)) return;
    final key = _cacheKeyForUrl(url);
    if (_cachedCacheKeys.contains(key)) return;
    if (_inFlightCacheKeys.contains(key)) return;
    _inFlightCacheKeys.add(key);
    try {
      await _downloadProgressive(url);
      _cachedCacheKeys.add(key);
    } catch (e) {
      debugPrint('[VideoRepository] cache download failed → $e');
    } finally {
      _inFlightCacheKeys.remove(key);
    }
  }

  Future<void> _downloadProgressive(String url) async {
    final key = _cacheKeyForUrl(url);
    await cacheManager.downloadFile(url, key: key);
  }
}
