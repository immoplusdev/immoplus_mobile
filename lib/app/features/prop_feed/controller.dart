import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'model.dart';
import 'repo.dart';

class VideoFeedController extends GetxController {
  final VideoRepository _repository = VideoRepository();

  final RxList<VideoModel> videos = <VideoModel>[].obs;
  final Map<int, VideoPlayerController> _controllers = {};
  final Map<String, VideoPlayerController> _cachedControllers = {};
  Map<int, VideoPlayerController> get controllers => _controllers;

  final RxInt currentIndex = 0.obs;
  final int poolSize = 5; // Réduit pour limiter stutter / trop de décodeurs sur Android

  /// Délègue au repo (évite Get.find<VideoRepository>() dans la vue).
  Future<File?> getCachedFile(String url) => _repository.getCachedFile(url);

  final Map<String, Future<String?>> _thumbnailFutures = {};

  /// Miniature générée depuis la vidéo (1re frame), mise en cache fichier. Même Future par URL pour éviter re-génération.
  Future<String?> getThumbnailPathForVideo(String url) {
    _thumbnailFutures[url] ??= _repository.getThumbnailPathForVideo(url).then((path) {
      if (!isClosed) update();
      return path;
    });
    return _thumbnailFutures[url]!;
  }

  @override
  void onInit() {
    super.onInit();
    videos.assignAll(_repository.getVideos());

    // Ne pas attendre le scan du cache : charger la 1re vidéo tout de suite.
    _repository.initializeCacheMetadata(); // en arrière-plan
    _loadFirstThenPreload();
  }

  Future<void> _loadFirstThenPreload() async {
    // Démarrer la vidéo suivante en parallèle (prête au premier scroll).
    if (videos.length > 1) _preloadSingle(1);
    final firstCtrl = await _createControllerFromUrl(videos[0].url);
    if (isClosed) {
      firstCtrl?.dispose();
      return;
    }
    if (firstCtrl != null) {
      _controllers[0] = firstCtrl..play();
      update();
    } else {
      firstCtrl?.dispose();
    }
    preloadWindow(0);
  }

  /// Create controller → use cache if available, else stream URL and cache in background
  Future<VideoPlayerController?> _createControllerFromUrl(String url) async {
    final startTime = DateTime.now();
    try {
      // Check if we already have a controller for this URL
      if (_cachedControllers.containsKey(url)) {
        final controller = _cachedControllers[url]!;
        if (controller.value.isInitialized) {
          debugPrint('[VideoFeedController] Reusing cached controller → $url');
          return controller;
        } else {
          controller.dispose();
          _cachedControllers.remove(url);
        }
      }

      File? file = await _repository.getCachedFile(url);
      late VideoPlayerController controller;
      if (file != null) {
        controller = VideoPlayerController.file(file);
        debugPrint('[VideoFeedController] Using cached file → $url');
      } else {
        controller = VideoPlayerController.networkUrl(Uri.parse(url));
        _repository.cacheInBackground(url);
        debugPrint('[VideoFeedController] Streaming from URL → $url');
      }

      await controller.initialize();
      debugPrint('[VideoFeedController] Initialized in ${DateTime.now().difference(startTime).inMilliseconds}ms → $url');
      controller.setLooping(true);

      // Store controller for cached files
      if (file != null) {
        _cachedControllers[url] = controller;
      }

      // attach runtime error listener
      controller.addListener(() {
        if (controller.value.hasError) {
          debugPrint(
              '[VideoFeedController] Playback error → ${controller.value.errorDescription}');
          _handleControllerError(controller, url);
        }
      });

      return controller;
    } catch (e, st) {
      debugPrint('[VideoFeedController] init failed for $url → $e\n$st');
      return null;
    }
  }

  Future<void> _handleControllerError(
      VideoPlayerController controller, String url) async {
    try {
      controller.pause();
      await controller.dispose();

      final retryCtrl = await _createControllerFromUrl(url);
      if (retryCtrl != null && !isClosed) {
        final idx = videos.indexWhere((v) => v.url == url);
        if (idx != -1) {
          _controllers[idx] = retryCtrl..pause();
          update();
        } else {
          retryCtrl.dispose();
        }
      }
    } catch (e) {
      debugPrint('[VideoFeedController] retry failed → $e');
    }
  }

  void preloadWindow(int index) {
    if (videos.isEmpty) return;

    currentIndex.value = index;
    final start = (index - poolSize ~/ 2).clamp(0, videos.length - 1);
    final end = (index + poolSize ~/ 2).clamp(0, videos.length - 1);

    // Ordre prioritaire : next (+1) puis +2, puis le reste (évite de saturer la bande passante).
    void loadOne(int i) {
      if (_controllers.containsKey(i)) return;
      _createControllerFromUrl(videos[i].url).then((ctrl) {
        if (ctrl == null) return;
        if (isClosed) {
          ctrl.dispose();
          return;
        }
        _controllers[i] = ctrl;
        if (i == currentIndex.value) {
          ctrl.play();
        } else {
          ctrl.pause();
        }
        update();
        _disposeFarControllers(currentIndex.value);
      });
    }

    if (index + 1 <= end && index + 1 < videos.length) loadOne(index + 1);
    if (index + 2 <= end && index + 2 < videos.length) loadOne(index + 2);
    for (int i = start; i <= end; i++) {
      if (i == index + 1 || i == index + 2) continue;
      loadOne(i);
    }
  }

  void onPageChanged(int index) async {
    currentIndex.value = index;

    // Précharge prioritaire : lancer tout de suite la (et la suivante) pour scroll fluide
    if (index + 1 < videos.length) _preloadSingle(index + 1);
    if (index + 2 < videos.length) _preloadSingle(index + 2);

    // Pause all except current
    _controllers.forEach((key, ctrl) {
      if (key != index) ctrl.pause();
    });

    final ctrl = _controllers[index];
    if (ctrl != null && ctrl.value.isInitialized) {
      ctrl.play();
    } else {
      final newCtrl = await _createControllerFromUrl(videos[index].url);
      if (!isClosed && newCtrl != null) {
        _controllers[index] = newCtrl..play();
        update();
      } else {
        newCtrl?.dispose();
      }
    }

    _disposeFarControllers(index);
  }

  Future<void> _preloadSingle(int index) async {
    if (_controllers.containsKey(index)) return;
    final ctrl = await _createControllerFromUrl(videos[index].url);
    if (!isClosed && ctrl != null) {
      _controllers[index] = ctrl..pause();
      update();
    } else {
      ctrl?.dispose();
    }
  }

  void _disposeFarControllers(int currentIdx) async {
    final keep = Set<int>();
    final halfPool = poolSize ~/ 2;
    for (int i = currentIdx - halfPool; i <= currentIdx + halfPool; i++) {
      if (i >= 0 && i < videos.length) {
        keep.add(i);
      }
    }

    final keys = List<int>.from(_controllers.keys);
    for (final key in keys) {
      if (!keep.contains(key)) {
        final url = videos[key].url;
        final cachedFile = await _repository.getCachedFile(url);
        if (cachedFile == null) {
          // Only dispose if the video is not cached
          _controllers[key]?.dispose();
          _controllers.remove(key);
        }
      }
    }
    update();
  }

  void togglePlayPause(int index) {
    final ctrl = _controllers[index];
    if (ctrl == null || !ctrl.value.isInitialized) return;

    if (ctrl.value.isPlaying) {
      ctrl.pause();
    } else {
      ctrl.play();
    }
    update();
  }

  VideoPlayerController? getController(int index) => _controllers[index];

  @override
  void onClose() {
    _controllers.forEach((_, c) => c.dispose());
    _cachedControllers.forEach((_, c) => c.dispose());
    _controllers.clear();
    _cachedControllers.clear();
    super.onClose();
  }
}