import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'model.dart';

class VideoRepository {
  final Dio _dio = Dio();

  // Persistent cache
  final CacheManager cacheManager = CacheManager(
    Config(
      'progressiveVideoCache',
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 200,
    ),
  );

  final Set<String> _cachedUrls = {};

  final List<VideoModel> _videos = [
    VideoModel(id: '1', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/b25e7392-0041-4731-b43a-370397011fde.mp4'),
    VideoModel(id: '2', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/7b323096-2df7-4ae1-b7ea-a8d0e2a5a96b.mp4'),
    VideoModel(id: '3', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/7942052a-3448-405f-96dd-7c0a36e4a090.mp4'),
    VideoModel(id: '4', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/487852a3-1f0f-4328-9c96-1c7672175e14.mp4'),
    VideoModel(id: '5', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/8236b95b-df97-4c6b-9f8d-f48319d82b74.mp4'),
    VideoModel(id: '6', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/22d323e2-1f3c-4260-aedd-eee052ef3490.mp4'),
    VideoModel(id: '7', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/874e7450-c249-4bbd-b454-16809c0b5a5a.mp4'),
    VideoModel(id: '8', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/de0618b3-ae40-41df-ad2a-8400ee908201.mp4'),
    VideoModel(id: '9', url: 'https://pub-1407f82391df4ab1951418d04be76914.r2.dev/uploads/e7cb7670-6692-478b-b137-b6430aaef23f.mp4'),
  ];

  VideoRepository();

  Future<void> initializeCacheMetadata() async {
    // Load cached URLs (this is a simplified example; use a proper cache index if needed)
    for (var video in _videos) {
      final cached = await cacheManager.getFileFromCache(video.url);
      if (cached != null && await cached.file.exists()) {
        _cachedUrls.add(video.url);
      }
    }
  }

  List<VideoModel> getVideos() => _videos;

  bool isStreamManifest(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.m3u8') || lower.contains('.mpd');
  }

  /// Returns cache file if exists, else null.
  /// Toujours interroge le cache (pas besoin d'attendre initializeCacheMetadata).
  Future<File?> getCachedFile(String url) async {
    final cached = await cacheManager.getFileFromCache(url);
    if (cached != null && await cached.file.exists()) {
      _cachedUrls.add(url);
      debugPrint('[VideoRepository] cache HIT → $url');
      return cached.file;
    }
    _cachedUrls.remove(url);
    return null;
  }

  static const int _thumbMaxHeight = 426;
  static const int _thumbQuality = 85;

  /// Génère une miniature à partir de la vidéo (1re frame) et la met en cache fichier.
  /// Retourne le chemin du fichier image, ou null si HLS/erreur.
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
      final createdPath = path.startsWith('/') ? path : '${thumbDir.path}/$path';
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

  /// Spawn isolate for progressive caching (non-blocking UI)
  Future<void> cacheInBackground(String url) async {
    if (isStreamManifest(url)) return;

    if (_cachedUrls.contains(url)) return;

    await compute(_downloadProgressive, {
      "url": url,
    });
    _cachedUrls.add(url); // Update cache metadata after download
  }

  /// Static function for isolate download
  static Future<void> _downloadProgressive(Map<String, dynamic> args) async {
    final url = args['url'] as String;
    final dio = Dio();

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${Uri.parse(url).pathSegments.last}');
      final sink = file.openWrite(mode: FileMode.writeOnly);

      final resp = await dio.get<ResponseBody>(
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
      debugPrint('[VideoRepository] cached in bg → $url');
    } catch (e) {
      debugPrint('[VideoRepository] isolate download failed → $e');
    }
  }

  static String _extractExtension(String url) {
    final idx = url.lastIndexOf('.');
    if (idx == -1) return 'mp4';
    return url.substring(idx + 1).split('?').first;
  }
}