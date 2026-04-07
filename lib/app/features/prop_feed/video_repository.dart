import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:immoplus/main.dart';

typedef FeedPage = ({List<VideoModel> items, String? cursor, bool hasMore});

// ---------------------------------------------------------------------------
// Configuration du cache vidéo
// ---------------------------------------------------------------------------

/// Cache dédié aux fichiers vidéo MP4 du feed.
/// ⚠️  Limité à 5 vidéos / 12h pour ne pas exploser le stockage utilisateur.
///     (200 vidéos de 100 MB = 20 GB — inacceptable sur mobile)
final CacheManager propFeedVideoCache = CacheManager(
  Config(
    'propfeed_video_cache_v2',
    stalePeriod: const Duration(hours: 12),
    maxNrOfCacheObjects: 5,
    repo: JsonCacheInfoRepository(databaseName: 'propfeed_video_cache_v2'),
    fileSystem: IOFileSystem('propfeed_video_cache_v2'),
    fileService: HttpFileService(),
  ),
);

// ---------------------------------------------------------------------------
// VideoRepository
// ---------------------------------------------------------------------------

class VideoRepository {
  VideoRepository() {
    _setupDioInterceptors();
  }

  // ── Réseau ─────────────────────────────────────────────────────────────────

  /// Dio avec timeouts explicites — évite les blocages réseau indéfinis.
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  String get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  void _setupDioInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(
        TalkerDioLogger(
          talker: talker,
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

  /// Retourne les headers HTTP communs à toutes les requêtes.
  /// Injecte automatiquement le Bearer token JWT si disponible.
  Future<Map<String, String>> _authHeaders() async {
    try {
      final sessionManager = GetIt.instance<SessionManager>();
      final user = await sessionManager.getCurrentUser();
      final token = user?.accessToken;
      if (token != null && token.isNotEmpty) {
        return {
          'Authorization': 'Bearer $token',
          'User-Agent': 'ImmoPlus/1.0 Flutter',
        };
      }
    } catch (_) {
      // SessionManager non disponible (ex: tests) — on continue sans token
    }
    return {'User-Agent': 'ImmoPlus/1.0 Flutter'};
  }

  // ── Cache vidéo MP4 ─────────────────────────────────────────────────────────

  final CacheManager cacheManager = propFeedVideoCache;

  /// Set des clés déjà en cache (évite les lookups disque inutiles).
  final Set<String> _cachedCacheKeys = <String>{};

  /// Queue de téléchargement sérialisée — 1 seul download actif à la fois.
  /// (Éviter de saturer la bande passante pendant la lecture en cours.)
  Future<void>? _activeDownload;
  final List<({String url, String key})> _pendingDownloads =
      <({String url, String key})>[];
  final Set<String> _pendingDownloadKeys = <String>{};

  // ── Cache thumbnail ──────────────────────────────────────────────────────────

  static const int _thumbMaxHeight = 426;
  static const int _thumbQuality = 85;

  // ---------------------------------------------------------------------------
  // Utilitaires URL
  // ---------------------------------------------------------------------------

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

  /// Clé de cache stable — ignore query string et fragment.
  /// Critique pour les URLs presignées (signature qui change à chaque appel).
  static String _cacheKeyForUrl(String url) {
    if (url.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null) return url.split('#').first.split('?').first;
    return uri.replace(query: '', fragment: '').toString();
  }

  bool isStreamManifest(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.m3u8') || lower.contains('.mpd');
  }

  String _normalizeUrl(String url) {
    if (url.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null) return url;
    if (_looksLikePresignedUrl(uri)) return url;
    if (!_isLocalhostHost(uri.host)) return url;
    return _baseUrl + uri.path + (uri.hasQuery ? '?${uri.query}' : '');
  }

  // ---------------------------------------------------------------------------
  // Feed API
  // ---------------------------------------------------------------------------

  Future<FeedPage> fetchFeed({String? cursor, int limit = 5}) async {
    final params = <String, dynamic>{'limit': limit};
    if (cursor != null) params['cursor'] = cursor;

    final headers = await _authHeaders();

    if (kDebugMode) {
      talker.info(
        '[VideoRepository] 📡 GET /feed?limit=$limit '
        '${cursor != null ? '(page suivante)' : '(initial)'} '
        '| auth=${headers.containsKey('Authorization') ? '✓ JWT' : '✗ aucun'}',
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/feed',
        queryParameters: params,
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        final etag = response.headers.value('etag');
        if (etag != null && etag.trim().isNotEmpty) {
          talker.debug('[VideoRepository] ↩︎ /feed etag=$etag');
        }
      }

      return _parseFeedPage(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 401) {
        talker.warning(
          '[VideoRepository] 🔐 401 Unauthorized — token expiré ou absent sur GET /feed',
        );
      } else if (status == 429) {
        final retryAfterHeader =
            e.response?.headers.value('retry-after')?.trim();
        final retryDelay = Duration(
          milliseconds: int.tryParse(retryAfterHeader ?? '') != null
              ? (int.parse(retryAfterHeader!) * 1000)
              : 800,
        );
        talker.warning(
          '[VideoRepository] ⏳ 429 rate limited; retry in ${retryDelay.inMilliseconds}ms',
        );
        await Future.delayed(retryDelay);
        try {
          final retryResponse = await _dio.get(
            '$_baseUrl/feed',
            queryParameters: params,
            options: Options(headers: headers),
          );
          return _parseFeedPage(retryResponse.data as Map<String, dynamic>);
        } catch (e2) {
          if (kDebugMode) talker.error('[VideoRepository] ❌ Retry failed', e2);
        }
      } else {
        if (kDebugMode) talker.error('[VideoRepository] ❌ fetchFeed', e);
      }

      return (items: <VideoModel>[], cursor: null, hasMore: false);
    } catch (e) {
      if (kDebugMode) talker.error('[VideoRepository] ❌ fetchFeed generic', e);
      return (items: <VideoModel>[], cursor: null, hasMore: false);
    }
  }

  Future<VideoModel?> fetchVideoDetail(String id) async {
    try {
      final headers = await _authHeaders();
      final response = await _dio.get(
        '$_baseUrl/feed/videos/$id',
        options: Options(headers: headers),
      );
      final data = (response.data as Map<String, dynamic>)['data'];
      if (data == null) return null;
      return VideoModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        talker.warning('[VideoRepository] fetchVideoDetail error → $e');
      }
      return null;
    }
  }

  FeedPage _parseFeedPage(Map<String, dynamic> data) {
    final rawList = data['data'] as List<dynamic>? ?? [];

    final items = <VideoModel>[];
    int filtered = 0;

    for (final e in rawList) {
      final json = Map<String, dynamic>.from(e as Map);
      if (json['videoUrl'] is String) {
        json['videoUrl'] = _normalizeUrl(json['videoUrl'] as String);
      }
      if (json['thumbnailUrl'] is String) {
        json['thumbnailUrl'] = _normalizeUrl(json['thumbnailUrl'] as String);
      }
      final video = VideoModel.fromJson(json);
      if (video.url.isEmpty) {
        filtered++;
        if (kDebugMode) {
          talker.debug('[Feed] Vidéo filtrée (URL vide): id=${video.id}');
        }
        continue;
      }
      items.add(video);
    }

    final nextCursor = data['cursor'] as String?;
    final hasMore = data['has_more'] as bool? ?? false;

    if (kDebugMode) {
      talker.info(
        '[Feed] ✓ ${items.length} vidéos valides '
        '(${filtered > 0 ? '$filtered filtrées, ' : ''}'
        'hasMore=$hasMore)',
      );
    }

    return (items: items, cursor: nextCursor, hasMore: hasMore);
  }

  // ---------------------------------------------------------------------------
  // Cache vidéo — Lecture
  // ---------------------------------------------------------------------------

  /// Vérifie le cache disque pour les [videos] données.
  /// Appelé au démarrage pour pré-remplir [_cachedCacheKeys].
  Future<void> initializeCacheMetadata(List<VideoModel> videos) async {
    for (final video in videos) {
      final key = _cacheKeyForUrl(video.url);
      final cached = await cacheManager.getFileFromCache(key);
      if (cached != null && await cached.file.exists()) {
        _cachedCacheKeys.add(key);
      }
    }
    if (kDebugMode) {
      talker.debug(
        '[VideoRepository:Cache] Init — ${_cachedCacheKeys.length}/${videos.length} vidéos en cache',
      );
    }
  }

  /// Retourne le fichier en cache pour [url], ou null si absent.
  Future<File?> getCachedFile(String url) async {
    if (isStreamManifest(url)) return null; // HLS ne se cache pas en fichier
    final key = _cacheKeyForUrl(url);
    final cached = await cacheManager.getFileFromCache(key);
    if (cached != null && await cached.file.exists()) {
      _cachedCacheKeys.add(key);
      if (kDebugMode) {
        talker.debug('[VideoRepository:Cache] HIT → ${key.split('/').last}');
      }
      return cached.file;
    }
    _cachedCacheKeys.remove(key);
    return null;
  }

  // ---------------------------------------------------------------------------
  // Cache vidéo — Écriture (background, sérialisé)
  // ---------------------------------------------------------------------------

  /// Déclenche le téléchargement en cache de [url] en arrière-plan.
  ///
  /// Règles :
  /// - HLS/DASH ignoré (segments gérés par le player natif)
  /// - WiFi → caching autorisé ✅
  /// - 4G/LTE (mobile) → caching autorisé ✅  (le player streame déjà la vidéo,
  ///   donc on utilise une bande passante déjà consommée)
  /// - Pas de réseau / offline → skip ⛔
  /// - Queue sérialisée : 1 download actif à la fois
  /// - Doublons ignorés (déjà en cache ou déjà en queue)
  Future<void> cacheInBackground(String url) async {
    if (isStreamManifest(url)) return;

    final key = _cacheKeyForUrl(url);
    if (_pendingDownloadKeys.contains(key)) return;

    // Vérifier le cache disque pour éviter les doublons (important si plusieurs
    // instances de VideoRepository existent, ex: warmup + controller).
    // Met aussi à jour _cachedCacheKeys si le cache a été évincé.
    final cached = await cacheManager.getFileFromCache(key);
    if (cached != null && await cached.file.exists()) {
      _cachedCacheKeys.add(key);
      return;
    }
    _cachedCacheKeys.remove(key);

    // Autoriser le cache sur WiFi ET mobile (4G/LTE).
    // On ne bloque que si l'utilisateur est hors ligne.
    // Rationale : le player streame déjà la vidéo, le download background
    // utilise la même bande passante — pas de consommation supplémentaire
    // significative. L'avantage : les vidéos sont disponibles hors-ligne après.
    final results = await Connectivity().checkConnectivity();
    final hasConnection = results.any(
      (r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile,
    );
    if (!hasConnection) {
      if (kDebugMode) {
        talker.debug('[VideoRepository:Cache] Skip (offline) → ${key.split('/').last}');
      }
      return;
    }

    _pendingDownloads.add((url: url, key: key));
    _pendingDownloadKeys.add(key);
    _processDownloadQueue();
  }

  /// Variante "warmup" : ne met en cache que sur Wi‑Fi.
  ///
  /// Utile au lancement (Accueil) pour éviter toute surprise data.
  Future<void> cacheInBackgroundWifiOnly(String url) async {
    if (isStreamManifest(url)) return;
    final results = await Connectivity().checkConnectivity();
    final hasWifi =
        results.any((r) => r == ConnectivityResult.wifi);
    if (!hasWifi) {
      if (kDebugMode) {
        final key = _cacheKeyForUrl(url);
        talker.debug(
          '[VideoRepository:Cache] Skip warmup (not wifi) → ${key.split('/').last}',
        );
      }
      return;
    }
    await cacheInBackground(url);
  }

  void _processDownloadQueue() {
    // Un download est déjà actif — attendre qu'il finisse
    if (_activeDownload != null) return;
    if (_pendingDownloads.isEmpty) return;

    final req = _pendingDownloads.removeAt(0);
    _pendingDownloadKeys.remove(req.key);
    final url = req.url;
    final key = req.key;

    // Peut avoir été mis en cache entre temps
    if (_cachedCacheKeys.contains(key)) {
      _processDownloadQueue();
      return;
    }

    if (kDebugMode) {
      talker.debug(
        '[VideoRepository:Cache] ⬇ Start download → ${key.split('/').last}',
      );
    }

    _activeDownload = _downloadAndRegister(url, key)
        .then((_) {
          _cachedCacheKeys.add(key);
          if (kDebugMode) {
            talker.info(
              '[VideoRepository:Cache] ✓ Cached → ${key.split('/').last}',
            );
          }
        })
        .catchError((Object e) {
          if (kDebugMode) {
            talker.warning('[VideoRepository:Cache] ⚠ Failed → $e');
          }
        })
        .whenComplete(() {
          _activeDownload = null;
          _processDownloadQueue(); // Traiter la vidéo suivante en queue
        });
  }

  /// Télécharge [url] dans un Isolate séparé (n'impacte pas l'UI thread)
  /// puis enregistre le fichier résultant dans [cacheManager].
  Future<void> _downloadAndRegister(String url, String key) async {
    // 1. Télécharger dans un Isolate (stream par chunks → pas d'OOM)
    final tmpPath = await compute(_downloadToTempFile, url);
    if (tmpPath == null) {
      throw Exception('Isolate download returned null for $url');
    }

    // 2. Enregistrer dans flutter_cache_manager
    final file = File(tmpPath);
    if (await file.exists()) {
      try {
        final bytes = await file.readAsBytes();
        final ext = _extractExtension(url);
        await cacheManager.putFile(
          url,
          bytes,
          key: key,
          fileExtension: ext,
          maxAge: const Duration(hours: 12),
        );
      } finally {
        // Toujours nettoyer le fichier temporaire
        await file.delete().catchError((_) => file as FileSystemEntity);
      }
    }
  }

  /// Exécutée dans un Isolate séparé via [compute].
  /// Télécharge [url] par stream de chunks → safe pour les gros fichiers MP4.
  /// Retourne le chemin du fichier temporaire, ou null en cas d'erreur.
  static Future<String?> _downloadToTempFile(String url) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    try {
      final dir = await getTemporaryDirectory();
      final segments = Uri.tryParse(url)?.pathSegments ?? <String>[];
      final filename =
          segments.isNotEmpty ? segments.last : 'propfeed_${url.hashCode}.mp4';
      final tmpFile = File('${dir.path}/propfeed_dl_$filename');

      // Stream progressif par chunks — aucun risque d'OOM sur gros fichiers
      final resp = await dio.get<ResponseBody>(
        url,
        options: Options(responseType: ResponseType.stream),
      );

      final sink = tmpFile.openWrite();
      await for (final chunk in resp.data!.stream) {
        sink.add(chunk);
      }
      await sink.close();

      debugPrint(
        '[VideoRepository:Isolate] ✓ ${tmpFile.lengthSync()} bytes → $filename',
      );
      return tmpFile.path;
    } catch (e) {
      debugPrint('[VideoRepository:Isolate] ✗ $e');
      return null;
    } finally {
      dio.close();
    }
  }

  static String _extractExtension(String url) {
    final idx = url.lastIndexOf('.');
    if (idx == -1) return 'mp4';
    return url.substring(idx + 1).split('?').first.split('#').first;
  }

  // ---------------------------------------------------------------------------
  // Thumbnail — Génération locale (fallback si thumbnailUrl absent du backend)
  // ---------------------------------------------------------------------------

  /// Génère une miniature depuis la 1ʳᵉ frame de [videoUrl].
  /// Met en cache fichier pour éviter de régénérer à chaque rebuild.
  /// Retourne null si HLS, si la vidéo est inaccessible, ou en cas d'erreur.
  Future<String?> getThumbnailPathForVideo(String videoUrl) async {
    if (isStreamManifest(videoUrl)) return null;

    final dir = await getTemporaryDirectory();
    final thumbDir = Directory('${dir.path}/propfeed_thumbnails');
    if (!await thumbDir.exists()) await thumbDir.create(recursive: true);

    final key = videoUrl.hashCode.abs();
    final ourPath = '${thumbDir.path}/thumb_$key.jpg';
    if (await File(ourPath).exists()) return ourPath;

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
      if (kDebugMode) {
        talker.warning('[VideoRepository] Thumbnail failed → $e');
      }
      return null;
    }
  }
}
