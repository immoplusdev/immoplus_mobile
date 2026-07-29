import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:immoplus/app/features/prop_feed/video_repository.dart';
import 'package:immoplus/app/utils/request_path.dart';
import 'package:immoplus/main.dart';

/// Warmup du feed vidéo (avant que l'utilisateur ouvre l'onglet "Vivre").
///
/// Objectif : rendre le premier affichage instantané sans démarrer
/// les players / sockets (batterie + data).
///
/// - Précharge la 1ère page JSON (limit=5 par défaut)
/// - Précharge les thumbnails (coût très faible)
/// - Optionnel : met en cache la 1ère vidéo (Wi‑Fi uniquement)
class VideoFeedWarmupService extends GetxService {
  VideoFeedWarmupService({
    VideoRepository? repository,
    CacheManager? imageCacheManager,
  })  : _repository = repository ?? VideoRepository(),
        _imageCacheManager = imageCacheManager ?? DefaultCacheManager();

  final VideoRepository _repository;
  final CacheManager _imageCacheManager;

  FeedPage? _snapshot;
  DateTime? _snapshotAt;
  Future<FeedPage?>? _inFlight;

  /// Player pré-initialisé pour la vidéo 0 (consommé par VideoFeedController).
  VideoPlayerController? _preInitController;

  /// true dès que le FeedController a appelé [takePreInitializedController].
  /// Empêche le warmup de garder un player orphelin si le controller a déjà
  /// créé le sien.
  bool _playerTaken = false;

  FeedPage? get snapshot => _snapshot;
  bool get isInFlight => _inFlight != null;

  /// Transfère le player pré-initialisé au FeedController.
  /// Retourne null si pas encore prêt ou déjà consommé.
  VideoPlayerController? takePreInitializedController() {
    _playerTaken = true;
    final c = _preInitController;
    _preInitController = null;
    return c;
  }

  bool hasFreshSnapshot({Duration maxAge = const Duration(minutes: 10)}) {
    final snap = _snapshot;
    final at = _snapshotAt;
    if (snap == null || at == null) return false;
    if (snap.items.isEmpty) return false;
    return DateTime.now().difference(at) <= maxAge;
  }

  Future<FeedPage?> waitForSnapshot({
    Duration timeout = const Duration(milliseconds: 800),
  }) async {
    final inflight = _inFlight;
    if (inflight == null) return _snapshot;
    try {
      return await inflight.timeout(timeout);
    } catch (_) {
      return _snapshot;
    }
  }

  Future<FeedPage?> warmup({
    int limit = 5,
    int prefetchThumbnails = 5,
    bool cacheFirstVideoOnWifi = true,
  }) async {
    if (hasFreshSnapshot()) return _snapshot;
    if (_inFlight != null) return _inFlight!;

    _inFlight = _doWarmup(
      limit: limit,
      prefetchThumbnails: prefetchThumbnails,
      cacheFirstVideoOnWifi: cacheFirstVideoOnWifi,
    );

    try {
      return await _inFlight!;
    } finally {
      _inFlight = null;
    }
  }

  Future<FeedPage?> _doWarmup({
    required int limit,
    required int prefetchThumbnails,
    required bool cacheFirstVideoOnWifi,
  }) async {
    final startedAt = DateTime.now();
    try {
      final page = await _repository.fetchFeed(limit: limit);
      if (page.items.isEmpty) return null;

      _snapshot = page;
      _snapshotAt = DateTime.now();

      // Player pre-init : fire-and-forget — ne doit JAMAIS bloquer le snapshot
      unawaited(_preInitFirstPlayer(page.items.first.url));

      // Thumbs + cache vidéo en parallèle (rapide, OK à attendre)
      final futures = <Future<void>>[
        _prefetchThumbs(page.items, prefetchThumbnails),
      ];
      if (cacheFirstVideoOnWifi) {
        futures
            .add(_repository.cacheInBackgroundWifiOnly(page.items.first.url));
      }
      await Future.wait(futures);

      talker.debug(
        '[VideoFeed:Warmup] ✓ snapshot=${page.items.length} thumbs=${prefetchThumbnails.clamp(0, page.items.length)} '
        'player=${_preInitController != null ? 'ready' : 'skip'} '
        't=${DateTime.now().difference(startedAt).inMilliseconds}ms',
      );
      return page;
    } catch (e, st) {
      if (kDebugMode) {
        talker.warning('[VideoFeed:Warmup] ✗ failed → $e');
        talker.handle(st);
      }
      return null;
    }
  }

  /// Pré-initialise le VideoPlayerController de la première vidéo.
  /// Le controller est stocké dans [_preInitController] et sera récupéré
  /// par VideoFeedController via [takePreInitializedController].
  Future<void> _preInitFirstPlayer(String url) async {
    try {
      final cachedFile = await _repository.getCachedFile(url);
      final controller = cachedFile != null
          ? VideoPlayerController.file(
              cachedFile,
              videoPlayerOptions: VideoPlayerOptions(
                mixWithOthers: true,
                allowBackgroundPlayback: false,
              ),
            )
          : VideoPlayerController.networkUrl(
              Uri.parse(url),
              videoPlayerOptions: VideoPlayerOptions(
                mixWithOthers: true,
                allowBackgroundPlayback: false,
              ),
            );

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0.0);

      if (_playerTaken) {
        // Le FeedController a déjà créé son propre player → dispose le nôtre
        controller.dispose();
        talker.debug(
            '[VideoFeed:Warmup] Player 0 disposed (controller already took over)');
        return;
      }

      _preInitController = controller;
      talker.debug('[VideoFeed:Warmup] ⚡ Player 0 pre-initialized');
    } catch (e) {
      if (kDebugMode) {
        talker.warning('[VideoFeed:Warmup] ✗ Player pre-init failed → $e');
      }
    }
  }

  @override
  void onClose() {
    _preInitController?.dispose();
    _preInitController = null;
    super.onClose();
  }

  Future<void> _prefetchThumbs(List<VideoModel> items, int maxCount) async {
    if (maxCount <= 0) return;
    final count = maxCount.clamp(0, items.length);
    for (final v in items.take(count)) {
      final url = _getThumbnailUrl(v);
      if (url == null || url.trim().isEmpty) continue;
      final key = _stableCacheKey(url);
      try {
        await _imageCacheManager
            .downloadFile(url, key: key)
            .timeout(const Duration(seconds: 6));
      } catch (_) {
        // Warmup best-effort : jamais bloquant
      }
    }
  }

  static String _stableCacheKey(String url) {
    if (url.trim().isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null) return url.split('#').first.split('?').first;
    return uri.replace(query: '', fragment: '').toString();
  }

  static String? _getThumbnailUrl(VideoModel video) {
    if (video.thumbnailUrl != null && video.thumbnailUrl!.trim().isNotEmpty) {
      return video.thumbnailUrl;
    }
    if (video.miniature != null && video.miniature!.trim().isNotEmpty) {
      final baseUrl = RequestPath.baseUrl.trim();
      if (baseUrl.isNotEmpty) {
        return '$baseUrl/files/raw/public/${video.miniature}';
      }
    }
    return null;
  }
}
