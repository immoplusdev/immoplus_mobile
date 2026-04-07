import 'package:flutter/material.dart';

import 'package:immoplus/app/features/prop_feed/video_feed_screen.dart';

/// Page "Vivre" — feed vidéo type TikTok.
class VivrePage extends StatelessWidget {
  const VivrePage({super.key, this.initialVideoId});

  final String? initialVideoId;

  static String name = 'VivrePage';

  @override
  Widget build(BuildContext context) {
    if (initialVideoId != null) {
      return VideoFeedView(initialVideoId: initialVideoId);
    }
    return const VideoFeedView();
  }
}
