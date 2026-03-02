import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:immoplus/app/features/prop_feed/video_model.dart';
import 'package:immoplus/app/features/prop_feed/video_repository.dart';

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

  int _currentIndex = 0;
  bool _isVisible = true;
  bool _hasBeenHidden = false;

  int get currentIndex => _currentIndex;
  bool get hasBeenHidden => _hasBeenHidden;
  bool get isVisible => _isVisible;

  VideoController? getVideoController(int index) => _videoControllers[index];

  bool isReadyAt(int index) => _readyIndexes.contains(index);

  bool isPlayingAt(int index) => _players[index]?.state.playing ?? false;

  Future<String?> getThumbnailPathForVideo(String url) =>
      _repository.getThumbnailPathForVideo(url);

  @override
  void onInit() {
    super.onInit();
    videos.assignAll(_repository.getVideos());
    if (videos.isEmpty) {
      return;
    }
    _preloadThumbnails();
    _initializeFirstVideo();
  }

  void _preloadThumbnails() {
    final count = videos.length.clamp(0, 3);
    for (int i = 0; i < count; i++) {
      _repository.getThumbnailPathForVideo(videos[i].url);
    }
  }

  Future<void> _initializeFirstVideo() async {
    await initPlayer(0, videos[0].url);
    if (isClosed ||
        !_isVisible ||
        _currentIndex != 0 ||
        !_readyIndexes.contains(0)) {
      return;
    }
    _players[0]?.setVolume(100.0);
    _players[0]?.play();
    _preloadWindow(0);
    _disposeDistantPlayers(0);
    update();
  }

  Future<String> _resolveMediaSource(String url) async {
    final cachedFile = await _repository.getCachedFile(url);
    if (cachedFile != null) {
      return Uri.file(cachedFile.path).toString();
    }
    _repository.cacheInBackground(url);
    return url;
  }

  Future<void> initPlayer(int index, String url) async {
    if (index < 0 || index >= videos.length) {
      return;
    }
    if (_readyIndexes.contains(index)) {
      return;
    }

    final inFlight = _readyCompleters[index];
    if (inFlight != null) {
      return inFlight.future;
    }

    final completer = Completer<void>();
    _readyCompleters[index] = completer;
    _initializingIndexes.add(index);

    final player = _players[index] ?? Player();
    final videoController = _videoControllers[index] ?? VideoController(player);

    // Expose controller immediately so UI can render loading state sooner.
    _players[index] = player;
    _videoControllers[index] = videoController;
    update(<Object>['video_$index']);

    try {
      await player.setPlaylistMode(PlaylistMode.single);
      await player.setVolume(100.0);
      final mediaSource = await _resolveMediaSource(url);
      await player.open(Media(mediaSource), play: false);

      if (isClosed) {
        player.stop();
        player.dispose();
        _players.remove(index);
        _videoControllers.remove(index);
        _readyIndexes.remove(index);
        if (!completer.isCompleted) {
          completer.complete();
        }
        return;
      }

      _readyIndexes.add(index);
      if (!completer.isCompleted) {
        completer.complete();
      }
      _disposeDistantPlayers(_currentIndex);
      update(<Object>['video_$index']);
    } catch (e, st) {
      debugPrint('[VideoFeedController] init failed for $url -> $e\n$st');
      _readyIndexes.remove(index);
      _players.remove(index);
      _videoControllers.remove(index);
      try {
        await player.dispose();
      } catch (_) {}
      if (!completer.isCompleted) {
        completer.complete();
      }
    } finally {
      _initializingIndexes.remove(index);
      _readyCompleters.remove(index);
    }
  }

  void _preloadWindow(int index) {
    if (videos.isEmpty) {
      return;
    }
    final indices = <int>[index + 1, index + 2];
    for (final i in indices) {
      if (i < 0 || i >= videos.length) {
        continue;
      }
      if (_readyIndexes.contains(i) || _initializingIndexes.contains(i)) {
        continue;
      }
      initPlayer(i, videos[i].url);
    }
  }

  void onPageChanged(int index) {
    if (videos.isEmpty) {
      return;
    }

    _currentIndex = index;

    for (final player in _players.values) {
      player.pause();
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

    _preloadWindow(index);
    _disposeDistantPlayers(index);
    update();
  }

  void _disposeDistantPlayers(int currentIdx) {
    if (videos.isEmpty) {
      return;
    }

    final keep = <int>{};
    for (final i in <int>[
      currentIdx - 1,
      currentIdx,
      currentIdx + 1,
      currentIdx + 2,
    ]) {
      if (i >= 0 && i < videos.length) {
        keep.add(i);
      }
    }

    final keys = List<int>.from(_players.keys);
    for (final key in keys) {
      if (keep.contains(key)) {
        continue;
      }
      final player = _players.remove(key);
      _videoControllers.remove(key);
      _readyIndexes.remove(key);
      _readyCompleters.remove(key);
      player?.stop();
      player?.dispose();
      update(<Object>['video_$key']);
    }
  }

  void playAt(int index) {
    if (!_isVisible || _currentIndex != index) {
      return;
    }
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
      if (entry.key != index) {
        entry.value.pause();
      }
    }
    player.setVolume(100.0);
    player.play();
    update(<Object>['video_$index']);
  }

  void pauseAt(int index) {
    final player = _players[index];
    if (player == null) {
      return;
    }
    player.pause();
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
      next = Random().nextInt(videos.length);
    } while (next == _currentIndex);
    return next;
  }

  void jumpToRandom() {
    final next = getRandomNextIndex();
    for (final p in _players.values) {
      p.pause();
    }
    _currentIndex = next;
    if (_players.containsKey(next) && _isVisible && _readyIndexes.contains(next)) {
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
    _preloadWindow(next);
    _disposeDistantPlayers(next);
    update();
  }

  void clearHasBeenHidden() {
    _hasBeenHidden = false;
  }

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
        if (entry.key != idx) {
          entry.value.pause();
        }
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

  /// Persiste l'horodatage de départ pour calculer la durée d'absence au retour.
  Future<void> saveSessionTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionTimestampKey, DateTime.now().toIso8601String());
  }

  /// Décide de reprendre exactement ou de rafraîchir selon la durée d'absence.
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

  /// Reprend la vidéo exactement à la position conservée par media_kit.
  /// Réinitialise le flag [_hasBeenHidden] pour que l'écran ne saute pas.
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
        if (!isClosed && _isVisible && _currentIndex == idx && _readyIndexes.contains(idx)) {
          _players[idx]?.setVolume(100.0);
          _players[idx]?.play();
          update(<Object>['video_$idx']);
        }
      });
    }
    update();
  }

  /// Dispose tous les players et laisse [_hasBeenHidden] à true.
  /// L'écran détectera ce flag et appellera _jumpToRandomPage().
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
    update();
  }

  @override
  void onClose() {
    for (final player in _players.values) {
      player.stop();
      player.dispose();
    }
    _players.clear();
    // VideoController has no public dispose API in media_kit_video 2.x.
    // Releasing Player instances frees underlying native video resources.
    _videoControllers.clear();
    _initializingIndexes.clear();
    _readyIndexes.clear();
    _readyCompleters.clear();
    super.onClose();
  }
}
