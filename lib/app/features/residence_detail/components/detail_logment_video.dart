import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/video_player/video_player_page.dart';

class DetailLogmentVideo extends StatelessWidget {
  const DetailLogmentVideo({
    super.key,
    required this.logmentModel,
  });
  final ResidenceModel logmentModel;

  @override
  Widget build(BuildContext context) {
    if (logmentModel.video.isEmpty) return const SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visite vidéo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child: VideoPlayerPage(videoID: logmentModel.video),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
