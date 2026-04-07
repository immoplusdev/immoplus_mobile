import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Lecteur vidéo intelligent qui adapte son affichage selon le format
/// (Portrait vs Paysage) en utilisant [VideoPlayerValue.aspectRatio].
///
/// - **Vertical** (aspectRatio < 1) : plein écran type TikTok avec [BoxFit.cover]
/// - **Horizontal** (aspectRatio >= 1) : conteneur au ratio natif avec [BoxFit.contain]
class SmartVideoPlayer extends StatelessWidget {
  const SmartVideoPlayer({
    super.key,
    required this.controller,
  });

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final aspectRatio = controller.value.aspectRatio;
    final isVertical = aspectRatio <= 0 || aspectRatio < 1.0;

    if (isVertical) {
      // Format vertical (portrait) : plein écran type TikTok
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
      );
    }

    // Format horizontal (paysage) : ratio natif, image entière sans rognage
    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}
