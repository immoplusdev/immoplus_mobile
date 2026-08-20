import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoID;

  /// URL directe (ex: HLS `.m3u8` du feed) — si fournie, remplace la
  /// construction d'URL habituelle via `Utils.getVideoPath(id: videoID)`.
  final String? videoUrl;

  /// Optional builder for a custom error widget.
  /// Receives [retry] — a callback that re-triggers video initialisation.
  /// When null the default error UI is shown.
  final Widget Function(VoidCallback retry)? buildErrorWidget;

  /// Lecture automatique dès le chargement (défaut: false).
  final bool autoPlay;

  /// Lecture en boucle (défaut: false).
  final bool looping;

  /// Affiche les contrôles Chewie (play/pause, scrubber, plein écran) et
  /// l'icône "play" avant chargement. À false pour une lecture silencieuse
  /// sans aucune indication (ex: teaser pub). Défaut: true.
  final bool showControls;

  /// Coupe le son au démarrage (défaut: false).
  final bool muted;

  const VideoPlayerPage({
    super.key,
    required this.videoID,
    this.videoUrl,
    this.buildErrorWidget,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.muted = false,
  });

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isMuted = false;

  void _toggleMute() {
    final controller = _videoPlayerController;
    if (controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeAndPlayVideo();
  }

  Future<void> _initializeAndPlayVideo() async {
    // URL directe (ex: HLS du feed) si fournie, sinon construction habituelle
    // via l'ID (en dev (FLAVOR=dev) : URL dev. En prod : URL prod).
    final String? videoUrl = widget.videoUrl?.isNotEmpty == true
        ? widget.videoUrl
        : Utils.getVideoPath(id: widget.videoID);
    if (videoUrl == null || videoUrl.isEmpty) {
      log('Vidéo: baseUrl ou videoID manquant → impossible de lire la vidéo');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Impossible de lire la vidéo';
        });
      }
      return;
    }
    log('Tentative de chargement de la vidéo: $videoUrl');

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Créer le contrôleur vidéo
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      // Initialiser avec timeout et gestion d'erreur
      await _videoPlayerController!.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: La vidéo prend trop de temps à charger');
        },
      );

      // Vérifier si le widget est toujours monté
      if (!mounted) return;

      // Vérifier si la vidéo a bien une durée (indicateur qu'elle est valide)
      if (_videoPlayerController!.value.duration == Duration.zero) {
        throw Exception('Vidéo invalide ou corrompue');
      }

      _isMuted = widget.muted;
      if (widget.muted) {
        await _videoPlayerController!.setVolume(0);
      }

      if (widget.showControls) {
        // Chewie ne sert qu'à afficher les contrôles (play/pause, scrubber,
        // plein écran) : il force son propre AspectRatio en interne, ce qui
        // laisse des bandes vides si la vidéo source n'a pas exactement le
        // ratio demandé. Inutile ici quand aucun contrôle n'est affiché.
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: widget.autoPlay,
          looping: widget.looping,
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Theme.of(context).primaryColor,
            handleColor: Theme.of(context).primaryColor,
            // backgroundColor: Colors.red,
            bufferedColor: Colors.lightGreen,
          ),
          placeholder: const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 80,
            ),
          ),
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de lecture vidéo',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // Pas de Chewie : on pilote directement le VideoPlayerController et
        // on remplit tout le cadre en "cover" (voir _buildCoverVideo), sans
        // aucune bande vide liée au ratio natif de la vidéo.
        await _videoPlayerController!.setLooping(widget.looping);
        if (widget.autoPlay) {
          await _videoPlayerController!.play();
        }
      }

      setState(() {
        _isLoading = false;
      });

      log('Vidéo initialisée avec succès');

      // Optionnel: Afficher un SnackBar de succès
      // if (mounted) {
      //   ToastUtils.success('Vidéo chargée avec succès');
      // }
    } catch (e) {
      log('Erreur lors de la lecture de la vidéo : $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    // Nettoyer les contrôleurs dans le bon ordre
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildShimmerEffect();
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    final controller = _videoPlayerController;
    if (controller != null && controller.value.isInitialized) {
      if (!widget.showControls) {
        return _buildCoverVideo(controller);
      }
      if (_chewieController != null) {
        return SizedBox(
          height: 300,
          child: Chewie(controller: _chewieController!),
        );
      }
    }

    return _buildErrorWidget();
  }

  /// Remplit tout le cadre disponible sans bande vide, en rognant l'excédent
  /// si le ratio natif de la vidéo diffère du cadre (BoxFit.cover), au lieu
  Widget _buildCoverVideo(VideoPlayerController controller) {
    final video = SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: GestureDetector(
              onTap: _toggleMute,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!widget.autoPlay) return video;

    return VisibilityDetector(
      key: ValueKey('video_player_visibility_${widget.videoID}'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.5) {
          if (!controller.value.isPlaying) controller.play();
        } else if (info.visibleFraction < 0.1) {
          if (controller.value.isPlaying) controller.pause();
        }
      },
      child: video,
    );
  }

  // Widget d'erreur — utilise le builder custom si fourni, sinon le UI par défaut.
  Widget _buildErrorWidget() {
    if (widget.buildErrorWidget != null) {
      return widget.buildErrorWidget!(_initializeAndPlayVideo);
    }

    return Container(
      width: double.infinity,
      height: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Impossible de lire la vidéo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _initializeAndPlayVideo,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  // Effet Shimmer amélioré
  Widget _buildShimmerEffect() {
    return Container(
      width: double.infinity,
      height: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Chargement de la vidéo...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
