import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoID;

  const VideoPlayerPage({super.key, required this.videoID});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeAndPlayVideo();
  }

  Future<void> _initializeAndPlayVideo() async {
    final String videoUrl =
        "https://api-v2.immoplus.ci/files/videos/raw/public/${widget.videoID}";
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

      // Initialiser ChewieController seulement après succès
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).primaryColor,
          handleColor: Theme.of(context).primaryColor,
          // backgroundColor: Colors.red,
          bufferedColor: Colors.lightGreen,
        ),
        placeholder: Container(
          // color: Colors.grey.shade200,
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 80,
              // color: Colors.grey,
            ),
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

    if (_chewieController != null &&
        _videoPlayerController!.value.isInitialized) {
      return SizedBox(
        height: 300,
        child: Chewie(controller: _chewieController!),
      );
    }

    return _buildErrorWidget();
  }

  // Widget d'erreur amélioré
  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      height: 250.0,
      decoration: BoxDecoration(
        // color: Colors.grey.shade100,
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
