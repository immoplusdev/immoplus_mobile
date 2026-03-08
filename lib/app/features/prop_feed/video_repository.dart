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
  final Set<String> _cachedUrls = {};

  String get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  // ---------------------------------------------------------------------------
  // Feed API — GET /feed
  // ---------------------------------------------------------------------------

  Future<FeedPage> fetchFeed({String? cursor, int limit = 5}) async {
    try {
      final params = <String, dynamic>{'limit': limit};
      if (cursor != null) {
        params['cursor'] = cursor;
        talker.info(
          '[VideoRepository] 📡 GET /feed?limit=$limit (pagination) | '
          'cursor=${cursor.substring(0, 8)}... | TikTok-like incremental load'
        );
      } else {
        talker.info('[VideoRepository] 📡 GET /feed?limit=$limit (initial) | First batch of videos');
      }

      final response = await _dio.get(
        '$_baseUrl/feed',
        queryParameters: params,
      );
      return _parseFeedPage(response.data as Map<String, dynamic>);
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
    if (uri.host != 'localhost' && uri.host != '127.0.0.1') return url;
    return _baseUrl +
        uri.path +
        (uri.hasQuery ? '?${uri.query}' : '');
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
      'received=$rawList | valid=${items.length} | filtered=$filtered | '
      'nextCursor=${nextCursor?.substring(0, 8) ?? 'null'}... | hasMore=$hasMore'
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
      final cached = await cacheManager.getFileFromCache(video.url);
      if (cached != null && await cached.file.exists()) {
        _cachedUrls.add(video.url);
      }
    }
  }

  bool isStreamManifest(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.m3u8') || lower.contains('.mpd');
  }

  Future<File?> getCachedFile(String url) async {
    final cached = await cacheManager.getFileFromCache(url);
    if (cached != null && await cached.file.exists()) {
      _cachedUrls.add(url);
      return cached.file;
    }
    _cachedUrls.remove(url);
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
    if (_cachedUrls.contains(url)) return;
    try {
      await _downloadProgressive(url);
      _cachedUrls.add(url);
    } catch (e) {
      debugPrint('[VideoRepository] cache download failed → $e');
    }
  }

  Future<void> _downloadProgressive(String url) async {
    final dir = await getTemporaryDirectory();
    final lastSegment = Uri.parse(url).pathSegments.lastOrNull ?? 'video';
    final file = File('${dir.path}/vid_${lastSegment.hashCode.abs()}_$lastSegment');
    final sink = file.openWrite(mode: FileMode.writeOnly);
    final resp = await _dio.get<ResponseBody>(
      url,
      options: Options(responseType: ResponseType.stream),
    );
    await for (final chunk in resp.data!.stream) {
      sink.add(chunk);
    }
    await sink.close();
    final bytes = await file.readAsBytes();
    await file.delete();
    await cacheManager.putFile(
      url,
      bytes,
      fileExtension: _extractExtension(url),
    );
  }

  static String _extractExtension(String url) {
    final idx = url.lastIndexOf('.');
    if (idx == -1) return 'mp4';
    return url.substring(idx + 1).split('?').first;
  }
}
