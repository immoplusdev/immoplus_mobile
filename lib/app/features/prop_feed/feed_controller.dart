import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/prop_feed/feed_socket_service.dart';
import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:immoplus/app/features/prop_feed/video_repository.dart';
import 'package:immoplus/main.dart';

class VideoFeedController extends GetxController {
  VideoFeedController() : _repository = VideoRepository();

  static const int _refreshThresholdMinutes = 30;
  static const String _sessionTimestampKey = 'last_session_timestamp';

  final VideoRepository _repository;

  final RxList<VideoModel> videos = <VideoModel>[].obs;

  final Map<int, Player> _players = <int, Player>{};
  final Map<int, VideoController> _videoControllers = <int, VideoController>{};
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

  VideoController? getVideoController(int index) => _videoControllers[index];
  bool isReadyAt(int index) => _readyIndexes.contains(index);
  bool isPlayingAt(int index) => _players[index]?.state.playing ?? false;

  int getLikesCountForVideo(String videoId) => _likesCount[videoId] ?? 0;
  bool getIsLikedForVideo(String videoId) => _isLiked[videoId] ?? false;

  Future<String?> getThumbnailPathForVideo(String url) =>
      _repository.getThumbnailPathForVideo(url);

  @override
  void onInit() {
    super.onInit();
    _fetchFeed();
  }

  // ---------------------------------------------------------------------------
  // API + socket
  // ---------------------------------------------------------------------------

  Future<void> _fetchFeed() async {
    talker.info('[VideoFeed] 📺 Initializing feed (TikTok-like pagination: limit=5)...');
    final result = await _repository.fetchFeed(); // limit=5 by default
    _cursor = result.cursor;
    _hasMore = result.hasMore;
    _initLikesFromItems(result.items);
    videos.assignAll(result.items);

    talker.info(
      '[VideoFeed] ✓ Initial buffer loaded: ${result.items.length} videos | '
      'Strategy: 1 visible + 1 prefetch + 3 buffer | '
      'cursor=${_cursor?.substring(0, 8) ?? 'null'}... | hasMore=$_hasMore'
    );

    if (videos.isEmpty) {
      talker.warning('[VideoFeed] ⚠️ Feed is empty');
      return;
    }
    _initializeFirstVideo();
    _connectSocket();
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
      'cursor=${_cursor?.substring(0, 8) ?? 'null'}... | buffered=${videos.length} | players=${_players.length}'
    );

    try {
      final result = await _repository.fetchFeed(cursor: _cursor); // limit=5
      _cursor = result.cursor;
      _hasMore = result.hasMore;
      _initLikesFromItems(result.items);

      if (result.items.isNotEmpty) {
        videos.addAll(result.items);
        talker.info(
          '[VideoFeed:Pagination] ✓ Buffer extended: +${result.items.length} | '
          'total buffer=${videos.length} | '
          'nextCursor=${_cursor?.substring(0, 8) ?? 'null'}... | hasMore=$_hasMore | '
          'memory=Players(${_players.length})/Buffer(${videos.length})'
        );
      } else {
        talker.warning('[VideoFeed:Pagination] ⚠️ Empty response - no new videos');
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
  // Thumbnail (utilise thumbnailUrl ou miniature de l'API, plus de génération locale)
  // ---------------------------------------------------------------------------

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
    _players[0]?.play();
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

    final player = _players[index] ?? Player();
    final videoController = _videoControllers[index] ?? VideoController(player);

    _players[index] = player;
    _videoControllers[index] = videoController;
    update(<Object>['video_$index']);

    try {
      // Fire-and-forget : pas besoin d'attendre ces configs avant open()
      player.setPlaylistMode(PlaylistMode.single);
      // Ouvrir directement avec l'URL réseau (MediaKit stream nativement)
      await player.open(Media(url), play: false);
      // Cacher en arrière-plan pour les prochaines lectures
      _repository.cacheInBackground(url);

      if (isClosed) {
        player.stop();
        player.dispose();
        _players.remove(index);
        _videoControllers.remove(index);
        _readyIndexes.remove(index);
        if (!completer.isCompleted) completer.complete();
        return;
      }

      _readyIndexes.add(index);
      if (!completer.isCompleted) completer.complete();
      _disposeDistantPlayers(_currentIndex);
      update(<Object>['video_$index']);
    } catch (e, st) {
      debugPrint('[VideoFeedController] init failed for $url → $e\n$st');
      _readyIndexes.remove(index);
      _players.remove(index);
      _videoControllers.remove(index);
      try {
        await player.dispose();
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
    for (final i in <int>[index + 1, index + 2, index + 3]) {
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
        'ready=${_readyIndexes.length} | initializing=${_initializingIndexes.length}'
      );
    }
  }

  void onPageChanged(int index) {
    if (videos.isEmpty) return;

    final previousIndex = _currentIndex;
    _currentIndex = index;
    talker.debug('[VideoFeed:PageChange] Current index: $index / ${videos.length}');

    // Pagination : charger la suite quand proche de la fin
    if (!_isLoadingMore && _hasMore && index >= videos.length - 3) {
      talker.info(
        '[VideoFeed:Pagination] 🔔 Near end detected! '
        'index=$index >= ${videos.length} - 3'
      );
      _loadMore();
    }

    // Ne pauser que le player précédent (pas tous)
    if (previousIndex != index) {
      _players[previousIndex]?.pause();
    }

    final currentPlayer = _players[index];
    if (_isVisible && currentPlayer != null && _readyIndexes.contains(index)) {
      currentPlayer.setVolume(100.0);
      currentPlayer.play();
    } else if (index >= 0 && index < videos.length) {
      final url = videos[index].url;
      initPlayer(index, url).then((_) {
        if (isClosed ||
            !_isVisible ||
            _currentIndex != index ||
            !_readyIndexes.contains(index)) {
          return;
        }
        _players[index]?.setVolume(100.0);
        _players[index]?.play();
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
      currentIdx + 3,
    ]) {
      if (i >= 0 && i < videos.length) keep.add(i);
    }

    final keys = List<int>.from(_players.keys);
    for (final key in keys) {
      if (keep.contains(key)) continue;
      final player = _players.remove(key);
      _videoControllers.remove(key);
      _readyIndexes.remove(key);
      _readyCompleters.remove(key);
      player?.stop();
      player?.dispose();
      update(<Object>['video_$key']);
    }

    // Log memory status
    talker.debug(
      '[VideoFeed:Memory] Players in memory: ${_players.length} | '
      'Keep indices: $keep | Total videos buffered: ${videos.length}'
    );
  }

  void playAt(int index) {
    if (!_isVisible || _currentIndex != index) return;
    final player = _players[index];
    if (player == null || !_readyIndexes.contains(index)) {
      if (index >= 0 && index < videos.length) {
        initPlayer(index, videos[index].url).then((_) {
          if (!isClosed &&
              _isVisible &&
              _currentIndex == index &&
              _readyIndexes.contains(index)) {
            _players[index]?.setVolume(100.0);
            _players[index]?.play();
            update(<Object>['video_$index']);
          }
        });
      }
      return;
    }

    for (final entry in _players.entries) {
      if (entry.key != index) entry.value.pause();
    }
    player.setVolume(100.0);
    player.play();
    update(<Object>['video_$index']);
  }

  void pauseAt(int index) {
    _players[index]?.pause();
    update(<Object>['video_$index']);
  }

  void togglePlayPause(int index) {
    final player = _players[index];
    if (player == null || !_readyIndexes.contains(index)) {
      if (index >= 0 && index < videos.length) {
        _currentIndex = index;
        initPlayer(index, videos[index].url).then((_) {
          if (!isClosed &&
              _isVisible &&
              _currentIndex == index &&
              _readyIndexes.contains(index)) {
            _players[index]?.setVolume(100.0);
            _players[index]?.play();
            update(<Object>['video_$index']);
          }
        });
      }
      return;
    }

    if (player.state.playing) {
      player.pause();
    } else {
      _currentIndex = index;
      for (final p in _players.values) {
        p.pause();
      }
      if (_isVisible) {
        player.setVolume(100.0);
        player.play();
      }
    }
    update(<Object>['video_$index']);
  }

  int getRandomNextIndex() {
    if (videos.length <= 1) return 0;
    int next;
    do {
      next = (DateTime.now().millisecondsSinceEpoch % videos.length).toInt();
    } while (next == _currentIndex);
    return next;
  }

  void jumpToRandom() {
    final next = getRandomNextIndex();
    for (final p in _players.values) {
      p.pause();
    }
    _currentIndex = next;
    if (_players.containsKey(next) &&
        _isVisible &&
        _readyIndexes.contains(next)) {
      _players[next]!.setVolume(100.0);
      _players[next]!.play();
    } else if (next >= 0 && next < videos.length) {
      initPlayer(next, videos[next].url).then((_) {
        if (!isClosed &&
            _isVisible &&
            _currentIndex == next &&
            _readyIndexes.contains(next)) {
          _players[next]?.setVolume(100.0);
          _players[next]?.play();
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
    for (final player in _players.values) {
      player.pause();
    }
    update();
  }

  void onFeedVisible() {
    _isVisible = true;
    if (_hasBeenHidden) {
      for (final player in _players.values) {
        player.pause();
      }
    } else {
      final idx = _currentIndex;
      for (final entry in _players.entries) {
        if (entry.key != idx) entry.value.pause();
      }
    }
    if (!_hasBeenHidden) {
      if (_currentIndex >= 0 && _currentIndex < videos.length) {
        final current = _players[_currentIndex];
        if (current != null && _readyIndexes.contains(_currentIndex)) {
          current.setVolume(100.0);
          current.play();
        } else {
          final index = _currentIndex;
          initPlayer(index, videos[index].url).then((_) {
            if (!isClosed &&
                _isVisible &&
                _currentIndex == index &&
                _readyIndexes.contains(index)) {
              _players[index]?.setVolume(100.0);
              _players[index]?.play();
              update(<Object>['video_$index']);
            }
          });
        }
      }
    }
    update();
  }

  Future<void> saveSessionTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionTimestampKey, DateTime.now().toIso8601String());
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
    final current = _players[_currentIndex];
    if (current != null && _readyIndexes.contains(_currentIndex)) {
      for (final entry in _players.entries) {
        if (entry.key != _currentIndex) entry.value.pause();
      }
      current.setVolume(100.0);
      current.play();
    } else if (_currentIndex >= 0 && _currentIndex < videos.length) {
      final idx = _currentIndex;
      initPlayer(idx, videos[idx].url).then((_) {
        if (!isClosed &&
            _isVisible &&
            _currentIndex == idx &&
            _readyIndexes.contains(idx)) {
          _players[idx]?.setVolume(100.0);
          _players[idx]?.play();
          update(<Object>['video_$idx']);
        }
      });
    }
    update();
  }

  void _refreshFeed() {
    _isVisible = false;
    for (final player in _players.values) {
      player.stop();
      player.dispose();
    }
    _players.clear();
    _videoControllers.clear();
    _readyIndexes.clear();
    _initializingIndexes.clear();
    _readyCompleters.clear();
    // Reset pagination et re-fetch
    _cursor = null;
    _hasMore = true;
    _fetchFeed();
    update();
  }

  @override
  void onClose() {
    _socketService?.disconnect();
    for (final player in _players.values) {
      player.stop();
      player.dispose();
    }
    _players.clear();
    _videoControllers.clear();
    _initializingIndexes.clear();
    _readyIndexes.clear();
    _readyCompleters.clear();
    super.onClose();
  }
}
