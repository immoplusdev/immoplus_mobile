import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/prop_feed/feed_socket_service.dart';
import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:immoplus/app/features/prop_feed/video_repository.dart';
import 'package:immoplus/app/features/prop_feed/video_feed_warmup_service.dart';
import 'package:immoplus/main.dart';

class VideoFeedController extends GetxController {
  VideoFeedController() : _repository = VideoRepository();

  static const int _refreshThresholdMinutes = 30;
  static const String _sessionTimestampKey = 'last_session_timestamp';

  final VideoRepository _repository;

  final RxList<VideoModel> videos = <VideoModel>[].obs;

  final Map<int, VideoPlayerController> _controllers =
      <int, VideoPlayerController>{};
  final Set<int> _initializingIndexes = <int>{};
  final Set<int> _readyIndexes = <int>{};
  final Map<int, Completer<void>> _readyCompleters = <int, Completer<void>>{};

  // Pagination cursor
  String? _cursor;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // Likes state (source: stats API + WebSocket temps réel)
  final Map<String, int> _likesCount = <String, int>{};
  final Map<String, bool> _isLiked = <String, bool>{};

  // Socket
  FeedSocketService? _socketService;
  String? _socketActiveVideoId;

  int _currentIndex = 0;
  bool _isVisible = true;
  bool _hasBeenHidden = false;

  int get currentIndex => _currentIndex;
  bool get hasBeenHidden => _hasBeenHidden;
  bool get isVisible => _isVisible;

  VideoPlayerController? getVideoController(int index) => _controllers[index];
  bool isReadyAt(int index) => _readyIndexes.contains(index);
  bool isPlayingAt(int index) => _controllers[index]?.value.isPlaying ?? false;

  int getLikesCountForVideo(String videoId) => _likesCount[videoId] ?? 0;
  bool getIsLikedForVideo(String videoId) => _isLiked[videoId] ?? false;

  Future<String?> getThumbnailPathForVideo(String url) =>
      _repository.getThumbnailPathForVideo(url);

  static String _safeUrlForLogs(String url) {
    if (url.trim().isEmpty) return '<empty>';
    final uri = Uri.tryParse(url);
    if (uri == null) return url.split('?').first.split('#').first;
    return url.split('?').first.split('#').first;
  }

  void _logFeedItems(String scope, List<VideoModel> items) {
    final sample = items.take(3).map((v) {
      return <String, dynamic>{
        'id': v.id,
        'status': v.status,
        'videoUrl': _safeUrlForLogs(v.url),
        'thumbnailUrl': _safeUrlForLogs(v.thumbnailUrl ?? ''),
        'shortCode': v.shortCode,
        'authorId': v.author?.id,
        'relatedTo': <String, dynamic>{
          'entity': v.relatedTo?.entity,
          'id': v.relatedTo?.id,
        },
        'likes': v.stats?.likes,
        'views': v.stats?.views,
        'createdAt': v.createdAt,
      };
    }).toList();

    talker.debug(
      '[VideoFeed:$scope] items=${items.length} sample=$sample',
    );
  }

  /// Deep link : retourne l'index de la vidéo dans [videos].
  /// -1 si introuvable (le feed démarre normalement).
  Future<int> prepareDeepLink(String videoId) async {
    // Déjà dans la liste ?
    final existing = videos.indexWhere((v) => v.id == videoId);
    if (existing != -1) return existing;

    // Sinon, fetch et insert en tête
    final video = await _repository.fetchVideoDetail(videoId);
    if (video == null) return -1;
    videos.insert(0, video);
    _initLikesFromItems([video]);
    return 0;
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(_initFeed());
  }

  Future<void> _initFeed() async {
    FeedPage? warmPage;
    if (Get.isRegistered<VideoFeedWarmupService>()) {
      final warmup = Get.find<VideoFeedWarmupService>();
      if (warmup.hasFreshSnapshot()) {
        warmPage = warmup.snapshot;
      } else if (warmup.isInFlight) {
        warmPage = await warmup.waitForSnapshot();
      }
    }

    if (warmPage != null && warmPage.items.isNotEmpty) {
      _applyInitialPage(warmPage, source: 'Warmup');
      if (videos.isEmpty) return;

      // Récupérer le player pré-initialisé du warmup → démarrage instantané
      if (Get.isRegistered<VideoFeedWarmupService>()) {
        final preInit =
            Get.find<VideoFeedWarmupService>().takePreInitializedController();
        if (preInit != null && preInit.value.isInitialized) {
          _controllers[0] = preInit;
          _readyIndexes.add(0);
          if (_isVisible && _currentIndex == 0) {
            preInit.setVolume(1.0);
            preInit.play();
          }
          _socketEnterVideo(0);
          _preloadWindow(0);
          _connectSocket();
          update();
          talker.info(
              '[VideoFeed] ⚡ Instant start — pre-initialized player from warmup');
          return;
        }
      }

      _initializeFirstVideo();
      _connectSocket();
      return;
    }

    await _fetchFeed();
  }

  // ---------------------------------------------------------------------------
  // API + socket
  // ---------------------------------------------------------------------------

  Future<void> _fetchFeed() async {
    talker.info(
        '[VideoFeed] 📺 Initializing feed (TikTok-like pagination: limit=5)...');
    final result = await _repository.fetchFeed(); // limit=5 by default
    _applyInitialPage(result, source: 'Network');

    if (videos.isEmpty) {
      talker.warning('[VideoFeed] ⚠️ Feed is empty');
      return;
    }
    _initializeFirstVideo();
    _connectSocket();
  }

  void _applyInitialPage(FeedPage page, {required String source}) {
    _cursor = page.cursor;
    _hasMore = page.hasMore;
    _initLikesFromItems(page.items);

    if (videos.isNotEmpty) {
      // #23 — Deep-link robustness: if a video was already inserted (via prepareDeepLink),
      // we append the new ones avoiding duplicates to prevent the deep-link video
      // from being wiped out by the initial feed fetch.
      final existingIds = videos.map((v) => v.id).toSet();
      final toAdd =
          page.items.where((v) => !existingIds.contains(v.id)).toList();
      videos.addAll(toAdd);
    } else {
      videos.assignAll(page.items);
    }

    _logFeedItems('InitialFetch:$source', page.items);

    talker.info(
      '[VideoFeed] ✓ Initial buffer loaded ($source): ${page.items.length} videos | '
      'Strategy: 1 visible + 1 prefetch + 3 buffer | '
      'cursor=${_cursor?.substring(0, 8) ?? 'null'}... | hasMore=$_hasMore',
    );
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) {
      if (_isLoadingMore) {
        talker.debug('[VideoFeed:Pagination] ⏳ Already loading more...');
      }
      if (!_hasMore) {
        talker.info('[VideoFeed:Pagination] ✓ No more videos to load');
      }
      return;
    }

    _isLoadingMore = true;
    talker.info(
      '[VideoFeed:Pagination] 📥 Fetching 5 more videos (TikTok-like limit) | '
      'cursor=${_cursor?.substring(0, 8) ?? 'null'}... | buffered=${videos.length} | players=${_controllers.length}',
    );

    try {
      final result = await _repository.fetchFeed(cursor: _cursor); // limit=5
      _cursor = result.cursor;
      _hasMore = result.hasMore;
      _initLikesFromItems(result.items);
      _logFeedItems('LoadMore', result.items);

      if (result.items.isNotEmpty) {
        videos.addAll(result.items);
        talker.info(
          '[VideoFeed:Pagination] ✓ Buffer extended: +${result.items.length} | '
          'total buffer=${videos.length} | '
          'nextCursor=${_cursor?.substring(0, 8) ?? 'null'}... | hasMore=$_hasMore | '
          'memory=Players(${_controllers.length})/Buffer(${videos.length})',
        );
      } else {
        talker.warning(
            '[VideoFeed:Pagination] ⚠️ Empty response - no new videos');
      }
    } catch (e, st) {
      talker.error(
        '[VideoFeed:Pagination] ❌ Error loading more videos',
        e,
        st,
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  void _initLikesFromItems(List<VideoModel> items) {
    for (final v in items) {
      if (!_likesCount.containsKey(v.id)) {
        _likesCount[v.id] = v.stats?.likes ?? 0;
        _isLiked[v.id] = v.stats?.liked ?? false;
      }
    }
  }

  Future<void> _connectSocket() async {
    try {
      final sessionManager = getIt<SessionManager>();
      final user = await sessionManager.getCurrentUser();
      final token = user?.accessToken;
      if (token == null || token.isEmpty) return;

      final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.isEmpty) return;

      _socketService = FeedSocketService(
        onLikesUpdated: _onSocketLikesUpdated,
      );
      _socketService!.connect(baseUrl, token);
    } catch (e) {
      debugPrint('[VideoFeedController] socket connect failed → $e');
    }
  }

  void _onSocketLikesUpdated(String videoId, int likesCount, bool liked) {
    _likesCount[videoId] = likesCount;
    _isLiked[videoId] = liked;
    final idx = videos.indexWhere((v) => v.id == videoId);
    if (idx != -1) {
      update(<Object>['video_$idx']);
    }
  }

  // Appelé depuis VideoPageItem après 3 s de lecture
  void sendViewEvent(String videoId, int durationMs) {
    _socketService?.sendView(videoId, durationMs);
  }

  /// Cache la vidéo en arrière-plan (utile pour les MP4 progressifs).
  /// Déclenché après quelques secondes de visionnage pour éviter de télécharger
  /// des vidéos que l'utilisateur swipe immédiatement.
  void cacheVideoInBackground(String videoId) {
    final idx = videos.indexWhere((v) => v.id == videoId);
    if (idx == -1) return;
    _repository.cacheInBackground(videos[idx].url);
  }

  // Toggle like depuis VideoPageItem
  void toggleLike(String videoId) {
    final current = _isLiked[videoId] ?? false;
    // Mise à jour optimiste
    _isLiked[videoId] = !current;
    _likesCount[videoId] = (_likesCount[videoId] ?? 0) + (current ? -1 : 1);
    _socketService?.toggleLike(videoId);
    final idx = videos.indexWhere((v) => v.id == videoId);
    if (idx != -1) {
      update(<Object>['video_$idx']);
    }
  }

  /// Domaine public de partage. Lisible depuis l'env (SHARE_BASE_URL) ou valeur par défaut.
  static String get _shareBaseUrl =>
      dotenv.env['SHARE_BASE_URL'] ?? 'https://app.immoplus.ci';

  // Utilise le shortCode fourni par GET /feed pour partager le lien.
  Future<void> shareVideo(String videoId) async {
    final idx = videos.indexWhere((v) => v.id == videoId);
    if (idx == -1) return;
    final video = videos[idx];
    final code = video.shortCode;
    if (code != null && code.isNotEmpty) {
      final publicLink = '$_shareBaseUrl/v/$code';
      await SharePlus.instance.share(ShareParams(
        text: publicLink,
        subject: 'Découvrez ce bien sur Immoplus',
      ));
    } else {
      // Fallback : partager l'URL directe de la vidéo
      await SharePlus.instance.share(ShareParams(
        text: video.url,
        subject: 'Découvrez ce bien sur Immoplus',
      ));
    }
  }

  void _socketEnterVideo(int index) {
    if (index < 0 || index >= videos.length) return;
    final videoId = videos[index].id;
    if (_socketActiveVideoId == videoId) return;
    if (_socketActiveVideoId != null) {
      _socketService?.leaveVideo(_socketActiveVideoId!);
    }
    _socketActiveVideoId = videoId;
    _socketService?.enterVideo(videoId);
  }

  // ---------------------------------------------------------------------------
  // Player lifecycle
  // ---------------------------------------------------------------------------

  Future<void> _initializeFirstVideo() async {
    await initPlayer(0, videos[0].url);
    if (isClosed ||
        !_isVisible ||
        _currentIndex != 0 ||
        !_readyIndexes.contains(0)) {
      return;
    }
    _controllers[0]?.play();
    _socketEnterVideo(0);
    _preloadWindow(0);
    update();
  }

  Future<void> initPlayer(int index, String url) async {
    if (index < 0 || index >= videos.length) return;
    if (_readyIndexes.contains(index)) return;

    final inFlight = _readyCompleters[index];
    if (inFlight != null) return inFlight.future;

    final completer = Completer<void>();
    _readyCompleters[index] = completer;
    _initializingIndexes.add(index);

    // Réutiliser un contrôleur existant s'il y en a un, sinon en créer un nouveau
    var controller = _controllers[index];
    if (controller == null) {
      // Priorité au cache local pour éviter le réseau
      final cachedFile = await _repository.getCachedFile(url);
      if (cachedFile != null) {
        controller = VideoPlayerController.file(
          cachedFile,
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
        );
        talker.debug('[VideoFeed:Cache] ✓ Using cached file for index $index');
      } else {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(url),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
        );
      }
      _controllers[index] = controller;
    }

    update(<Object>['video_$index']);

    try {
      await controller.initialize();
      // Boucle infinie comme TikTok
      await controller.setLooping(true);
      // Volume à 0 par défaut, sera mis à 1 quand on lance la lecture
      await controller.setVolume(0.0);

      if (isClosed) {
        controller.dispose();
        _controllers.remove(index);
        _readyIndexes.remove(index);
        if (!completer.isCompleted) completer.complete();
        return;
      }

      _readyIndexes.add(index);

      // Buffering silencieux : lancer play() à volume 0 pour que le player
      // télécharge et décode les premières frames. Quand l'utilisateur swipe,
      // les frames sont déjà en mémoire → lecture instantanée.
      if (index == _currentIndex + 1) {
        controller.play();
        talker.debug(
          '[VideoFeed:Preload] ▶ Silent buffering started for index $index',
        );
      }

      // Le cache disque (téléchargement complet) est déclenché après quelques
      // secondes de visionnage (VideoPageItem → cacheVideoInBackground).

      if (!completer.isCompleted) completer.complete();
      _disposeDistantPlayers(_currentIndex);
      update(<Object>['video_$index']);
    } catch (e, st) {
      debugPrint('[VideoFeedController] init failed for $url → $e\n$st');
      _readyIndexes.remove(index);
      _controllers.remove(index);
      try {
        controller.dispose();
      } catch (_) {}
      if (!completer.isCompleted) completer.complete();
    } finally {
      _initializingIndexes.remove(index);
      _readyCompleters.remove(index);
    }
  }

  void _preloadWindow(int index) {
    if (videos.isEmpty) return;
    final toPreload = <int>[];
    for (final i in <int>[index + 1, index + 2]) {
      if (i < 0 || i >= videos.length) continue;
      if (_readyIndexes.contains(i) || _initializingIndexes.contains(i)) {
        continue;
      }
      toPreload.add(i);
      initPlayer(i, videos[i].url);
    }
    if (toPreload.isNotEmpty) {
      talker.debug(
        '[VideoFeed:Preload] Preloading indices: $toPreload | '
        'ready=${_readyIndexes.length} | initializing=${_initializingIndexes.length}',
      );
    }
  }

  void onPageChanged(int index) {
    if (videos.isEmpty) return;

    final previousIndex = _currentIndex;
    _currentIndex = index;
    talker.debug(
        '[VideoFeed:PageChange] Current index: $index / ${videos.length}');
    if (index >= 0 && index < videos.length) {
      final v = videos[index];
      talker.debug(
        '[VideoFeed:Scroll] idx=$index id=${v.id} '
        'status=${v.status} '
        'videoUrl=${_safeUrlForLogs(v.url)} '
        'thumbnailUrl=${_safeUrlForLogs(v.thumbnailUrl ?? '')} '
        'shortCode=${v.shortCode ?? ''} '
        'authorId=${v.author?.id ?? ''} '
        'relatedTo=${v.relatedTo?.entity ?? ''}:${v.relatedTo?.id ?? ''} '
        'likes=${getLikesCountForVideo(v.id)} liked=${getIsLikedForVideo(v.id)}',
      );
    }

    // Pagination : charger la suite quand proche de la fin
    if (!_isLoadingMore && _hasMore && index >= videos.length - 3) {
      talker.info(
        '[VideoFeed:Pagination] 🔔 Near end detected! '
        'index=$index >= ${videos.length} - 3',
      );
      _loadMore();
    }

    // Pauser l'ancien + couper le son des autres préchargés
    if (previousIndex != index) {
      _controllers[previousIndex]?.pause();
    }

    final current = _controllers[index];
    if (_isVisible && current != null && _readyIndexes.contains(index)) {
      // La vidéo tourne déjà en buffering silencieux → juste monter le volume
      current.setVolume(1.0);
      // S'assurer qu'elle joue (au cas où elle aurait été pausée)
      if (!current.value.isPlaying) {
        current.play();
      }
    } else if (index >= 0 && index < videos.length) {
      final url = videos[index].url;
      initPlayer(index, url).then((_) {
        if (isClosed ||
            !_isVisible ||
            _currentIndex != index ||
            !_readyIndexes.contains(index)) {
          return;
        }
        _controllers[index]?.setVolume(1.0);
        _controllers[index]?.play();
        update(<Object>['video_$index']);
      });
    }

    _socketEnterVideo(index);
    _preloadWindow(index);
    _disposeDistantPlayers(index);
    update();
  }

  void _disposeDistantPlayers(int currentIdx) {
    if (videos.isEmpty) return;

    final keep = <int>{};
    for (final i in <int>[
      currentIdx - 1,
      currentIdx,
      currentIdx + 1,
      currentIdx + 2,
    ]) {
      if (i >= 0 && i < videos.length) keep.add(i);
    }

    final keys = List<int>.from(_controllers.keys);
    for (final key in keys) {
      if (keep.contains(key)) continue;
      final controller = _controllers.remove(key);
      _readyIndexes.remove(key);
      _readyCompleters.remove(key);
      controller?.dispose();
      update(<Object>['video_$key']);
    }

    // Log memory status
    talker.debug(
      '[VideoFeed:Memory] Players in memory: ${_controllers.length} | '
      'Keep indices: $keep | Total videos buffered: ${videos.length}',
    );
  }

  void playAt(int index) {
    if (!_isVisible || _currentIndex != index) return;
    final controller = _controllers[index];
    if (controller == null || !_readyIndexes.contains(index)) {
      if (index >= 0 && index < videos.length) {
        initPlayer(index, videos[index].url).then((_) {
          if (!isClosed &&
              _isVisible &&
              _currentIndex == index &&
              _readyIndexes.contains(index)) {
            _controllers[index]?.setVolume(1.0);
            _controllers[index]?.play();
            update(<Object>['video_$index']);
          }
        });
      }
      return;
    }

    for (final entry in _controllers.entries) {
      if (entry.key != index) entry.value.pause();
    }
    controller.setVolume(1.0);
    controller.play();
    update(<Object>['video_$index']);
  }

  void pauseAt(int index) {
    _controllers[index]?.pause();
    update(<Object>['video_$index']);
  }

  void togglePlayPause(int index) {
    final controller = _controllers[index];
    if (controller == null || !_readyIndexes.contains(index)) {
      if (index >= 0 && index < videos.length) {
        _currentIndex = index;
        initPlayer(index, videos[index].url).then((_) {
          if (!isClosed &&
              _isVisible &&
              _currentIndex == index &&
              _readyIndexes.contains(index)) {
            _controllers[index]?.setVolume(1.0);
            _controllers[index]?.play();
            update(<Object>['video_$index']);
          }
        });
      }
      return;
    }

    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      _currentIndex = index;
      for (final c in _controllers.values) {
        c.pause();
      }
      if (_isVisible) {
        controller.setVolume(1.0);
        controller.play();
      }
    }
    update(<Object>['video_$index']);
  }

  int getRandomNextIndex() {
    if (videos.length <= 1) return 0;
    int next;
    do {
      next = Random().nextInt(videos.length);
    } while (next == _currentIndex);
    return next;
  }

  void jumpToRandom() {
    final next = getRandomNextIndex();
    for (final c in _controllers.values) {
      c.pause();
    }
    _currentIndex = next;
    if (_controllers.containsKey(next) &&
        _isVisible &&
        _readyIndexes.contains(next)) {
      _controllers[next]!.setVolume(1.0);
      _controllers[next]!.play();
    } else if (next >= 0 && next < videos.length) {
      initPlayer(next, videos[next].url).then((_) {
        if (!isClosed &&
            _isVisible &&
            _currentIndex == next &&
            _readyIndexes.contains(next)) {
          _controllers[next]?.setVolume(1.0);
          _controllers[next]?.play();
          update(<Object>['video_$next']);
        }
      });
    }
    _socketEnterVideo(next);
    _preloadWindow(next);
    _disposeDistantPlayers(next);
    update();
  }

  void clearHasBeenHidden() => _hasBeenHidden = false;

  void onFeedHidden() {
    _isVisible = false;
    _hasBeenHidden = true;
    // Tout pauser (y compris les buffers silencieux) pour économiser batterie/réseau
    for (final controller in _controllers.values) {
      controller.pause();
    }
    update();
  }

  void onFeedVisible() {
    _isVisible = true;
    if (_hasBeenHidden) {
      // Tout reste pausé — le saut aléatoire va relancer
      for (final controller in _controllers.values) {
        controller.pause();
      }
    } else {
      // Reprendre la vidéo courante + relancer le buffering silencieux des autres
      if (_currentIndex >= 0 && _currentIndex < videos.length) {
        final current = _controllers[_currentIndex];
        if (current != null && _readyIndexes.contains(_currentIndex)) {
          current.setVolume(1.0);
          current.play();
        } else {
          final index = _currentIndex;
          initPlayer(index, videos[index].url).then((_) {
            if (!isClosed &&
                _isVisible &&
                _currentIndex == index &&
                _readyIndexes.contains(index)) {
              _controllers[index]?.setVolume(1.0);
              _controllers[index]?.play();
              update(<Object>['video_$index']);
            }
          });
        }
      }
      // Relancer le buffering silencieux des vidéos préchargées
      _restartSilentBuffering();
    }
    update();
  }

  /// Relance le buffering silencieux (play volume 0) des vidéos préchargées
  /// autour de la vidéo courante, après un retour de pause.
  void _restartSilentBuffering() {
    for (final entry in _controllers.entries) {
      if (entry.key == _currentIndex) continue;
      if (!_readyIndexes.contains(entry.key)) continue;
      final c = entry.value;
      if (!c.value.isPlaying) {
        c.setVolume(0.0);
        c.play();
      }
    }
  }

  Future<void> saveSessionTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _sessionTimestampKey, DateTime.now().toIso8601String());
  }

  Future<void> onAppResumed() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionTimestampKey);
    if (raw == null) {
      _resumeCurrentPlayer();
      return;
    }
    final absence = DateTime.now().difference(DateTime.parse(raw)).inMinutes;
    final results = await Connectivity().checkConnectivity();
    final hasConnection = results.any((r) => r != ConnectivityResult.none);
    if (absence < _refreshThresholdMinutes) {
      _resumeCurrentPlayer();
    } else if (hasConnection) {
      _refreshFeed();
    } else {
      _resumeCurrentPlayer();
    }
  }

  void _resumeCurrentPlayer() {
    _isVisible = true;
    _hasBeenHidden = false;
    final current = _controllers[_currentIndex];
    if (current != null && _readyIndexes.contains(_currentIndex)) {
      for (final entry in _controllers.entries) {
        if (entry.key != _currentIndex) entry.value.pause();
      }
      current.setVolume(1.0);
      current.play();
    } else if (_currentIndex >= 0 && _currentIndex < videos.length) {
      final idx = _currentIndex;
      initPlayer(idx, videos[idx].url).then((_) {
        if (!isClosed &&
            _isVisible &&
            _currentIndex == idx &&
            _readyIndexes.contains(idx)) {
          _controllers[idx]?.setVolume(1.0);
          _controllers[idx]?.play();
          update(<Object>['video_$idx']);
        }
      });
    }
    update();
  }

  void _refreshFeed() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _readyIndexes.clear();
    _initializingIndexes.clear();
    _readyCompleters.clear();
    // Reset pagination et re-fetch
    _cursor = null;
    _hasMore = true;
    _isVisible = true; // Réactivé avant _fetchFeed pour que la 1ère vidéo puisse jouer
    _fetchFeed();
    update();
  }

  @override
  void onClose() {
    _socketService?.disconnect();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _initializingIndexes.clear();
    _readyIndexes.clear();
    _readyCompleters.clear();
    super.onClose();
  }
}
