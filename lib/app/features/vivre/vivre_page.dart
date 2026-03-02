import 'package:flutter/material.dart';

import 'package:immoplus/app/features/prop_feed/video_feed_screen.dart';

/// Page "Vivre" — feed vidéo type TikTok.
class VivrePage extends StatelessWidget {
  const VivrePage({super.key});

  static String name = 'VivrePage';

  @override
  Widget build(BuildContext context) {
    return const VideoFeedView();
  }
}
