import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoID;

  const VideoPlayerPage({super.key, required this.videoID});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  String? _localVideoPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndPlayVideo();
  }

  Future<void> _downloadAndPlayVideo() async {
    log("https://api-v2.immoplus.ci/files/raw/public/${widget.videoID}.mp4");
    try {
      // Télécharger la vidéo depuis l'URL et la stocker localement
      final http.Response response = await http.get(Uri.parse(
          "https://api-v2.immoplus.ci/files/raw/public/${widget.videoID}.mp4"));
      if (response.statusCode == 200) {
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath = tempDir.path;
        final File videoFile = File('$tempPath/temp_video.mp4');

        // Écrire les données vidéo dans un fichier local
        await videoFile.writeAsBytes(response.bodyBytes);

        // Initialiser VideoPlayerController avec le fichier local
        _videoPlayerController = VideoPlayerController.file(videoFile)
          ..initialize().then((_) {
            setState(() {
              _isLoading = false;
              _localVideoPath = videoFile.path;

              // Initialiser ChewieController
              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController,
                autoPlay: false,
                looping: false,
              );
            });
          });
      } else {
        throw Exception('Erreur lors du téléchargement de la vidéo');
      }
    } catch (e) {
      log(_videoPlayerController.value.errorDescription!);
      print('Erreur: $e');
    }
  }

  @override
  void dispose() {
    // Supprimer la vidéo locale si elle a été téléchargée
    if (_localVideoPath != null) {
      final File videoFile = File(_localVideoPath!);
      if (videoFile.existsSync()) {
        videoFile.deleteSync();
        print('Vidéo supprimée : $_localVideoPath');
      }
    }
    _chewieController!.pause();
    // Nettoyer les contrôleurs
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? _buildShimmerEffect() // Affiche l'effet Shimmer pendant le chargement
        : SizedBox(height: 320, child: Chewie(controller: _chewieController!));
  }

  // Simuler un effet Shimmer avec des containers en gradients
  Widget _buildShimmerEffect() {
    return Container(
      width: double.infinity,
      height: 250.0,
      decoration: const BoxDecoration(color: Colors.black),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 30,
            ),
          ),
        ],
      ),
    );
  }
}
