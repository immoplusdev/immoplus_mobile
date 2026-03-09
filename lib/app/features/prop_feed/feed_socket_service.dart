import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Callback déclenché quand le serveur diffuse une mise à jour de likes.
typedef LikesUpdatedCallback = void Function(
    String videoId, int likesCount, bool liked);

/// Service Socket.IO pour le namespace /feed.
///
/// Cycle de vie attendu :
///   1. Créer le service avec [onLikesUpdated].
///   2. Appeler [connect] avec le JWT et la base URL.
///   3. Appeler [enterVideo] / [leaveVideo] au changement de vidéo.
///   4. Appeler [sendView] après N secondes de lecture.
///   5. Appeler [toggleLike] au tap like.
///   6. Appeler [disconnect] quand le controller est fermé.
class FeedSocketService {
  FeedSocketService({required this.onLikesUpdated});

  final LikesUpdatedCallback onLikesUpdated;

  io.Socket? _socket;
  String? _activeVideoId;

  bool get isConnected => _socket?.connected ?? false;

  /// Connecte au namespace /feed avec le JWT fourni.
  /// [baseUrl] : ex. "http://localhost:3000" (sans trailing slash).
  void connect(String baseUrl, String accessToken) {
    _socket?.disconnect();

    _socket = io.io(
      '$baseUrl/feed',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint('[FeedSocket] connecté');
      if (_activeVideoId != null) {
        _emit('video:enter', {'video_id': _activeVideoId});
      }
    });

    _socket!.onConnectError((e) =>
        debugPrint('[FeedSocket] erreur de connexion → $e'));

    _socket!.onDisconnect((_) =>
        debugPrint('[FeedSocket] déconnecté'));

    _socket!.on('video:likes_updated', (data) {
      if (data is! Map) return;
      final map = Map<String, dynamic>.from(data);
      final videoId = map['video_id'] as String?;
      final likesCount = map['likes_count'] as int? ?? 0;
      final liked = map['liked'] as bool? ?? false;
      if (videoId != null) {
        onLikesUpdated(videoId, likesCount, liked);
      }
    });

    _socket!.connect();
  }

  void enterVideo(String videoId) {
    _activeVideoId = videoId;
    _emit('video:enter', {'video_id': videoId});
  }

  void leaveVideo(String videoId) {
    if (_activeVideoId == videoId) _activeVideoId = null;
    _emit('video:leave', {'video_id': videoId});
  }

  void sendView(String videoId, int watchDurationMs) {
    _emit('video:view', {
      'video_id': videoId,
      'watch_duration_ms': watchDurationMs,
    });
  }

  void toggleLike(String videoId) {
    _emit('video:like', {'video_id': videoId});
  }

  void _emit(String event, Map<String, dynamic> payload) {
    if (isConnected) {
      _socket!.emit(event, payload);
    }
  }

  void disconnect() {
    if (_activeVideoId != null) {
      leaveVideo(_activeVideoId!);
    }
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
