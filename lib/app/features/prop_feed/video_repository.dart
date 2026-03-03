import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/prop_feed/video_model.dart';

typedef FeedPage = ({List<VideoModel> items, String? cursor, bool hasMore});

class VideoRepository {
  VideoRepository();

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

  Future<FeedPage> fetchFeed({String? cursor, int limit = 10}) async {
    try {
      final params = <String, dynamic>{'limit': limit};
      if (cursor != null) params['cursor'] = cursor;
      final response = await _dio.get(
        '$_baseUrl/feed',
        queryParameters: params,
      );
      return _parseFeedPage(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[VideoRepository] fetchFeed error → $e');
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
    final items = rawList
        .map((e) {
          final json = Map<String, dynamic>.from(e as Map);
          // Corrige les URLs localhost retournées par le backend déployé
          if (json['videoUrl'] is String) {
            json['videoUrl'] = _normalizeUrl(json['videoUrl'] as String);
          }
          if (json['thumbnailUrl'] is String) {
            json['thumbnailUrl'] =
                _normalizeUrl(json['thumbnailUrl'] as String);
          }
          return VideoModel.fromJson(json);
        })
        .where((v) {
          if (v.url.isEmpty) return false;
          final uri = Uri.tryParse(v.url);
          if (uri == null) return false;
          final lastSegment =
              uri.pathSegments.isEmpty ? '' : uri.pathSegments.last;
          return lastSegment != 'undefined' && lastSegment.isNotEmpty;
        })
        .toList();
    return (
      items: items,
      cursor: data['cursor'] as String?,
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  // ---------------------------------------------------------------------------
  // Short URL — POST /short  (Auth requis)
  // ---------------------------------------------------------------------------

  /// Crée un short link pour la vidéo [feedVideoId].
  /// Retourne le [code] court (ex. "aB3xYz") — le contrôleur construit l'URL publique.
  Future<String?> createShortLink(String feedVideoId) async {
    try {
      final token = await _getAccessToken();
      final response = await _dio.post(
        '$_baseUrl/short',
        data: {'feedVideoId': feedVideoId},
        options: Options(
          headers: token != null
              ? {'Authorization': 'Bearer $token'}
              : null,
        ),
      );
      final body = response.data as Map<String, dynamic>;
      // On utilise "code" pour construire l'URL publique côté app.
      return body['code'] as String?;
    } catch (e) {
      debugPrint('[VideoRepository] createShortLink error → $e');
      return null;
    }
  }

  Future<String?> _getAccessToken() async {
    try {
      final user = await getIt<SessionManager>().getCurrentUser();
      return user?.accessToken;
    } catch (_) {
      return null;
    }
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
    final file = File('${dir.path}/${Uri.parse(url).pathSegments.last}');
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
    await DefaultCacheManager().putFile(
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
