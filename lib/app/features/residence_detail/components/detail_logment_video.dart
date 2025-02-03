import 'package:flutter/material.dart';
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
    return Visibility(
      visible: logmentModel.video.isNotEmpty,
      replacement: const SliverToBoxAdapter(),
      child: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(10),
          // height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: VideoPlayerPage(videoID: logmentModel.video),
        ),
      ),
    );
  }
}
