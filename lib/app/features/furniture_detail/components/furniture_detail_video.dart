import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/video_player/video_player_page.dart';

class FurnitureDetailVideo extends StatelessWidget {
  const FurnitureDetailVideo({
    super.key,
    required this.furnitureModel,
  });

  final FurnitureModel furnitureModel;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: furnitureModel.video.isNotEmpty,
      replacement: const SliverToBoxAdapter(),
      child: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: VideoPlayerPage(videoID: furnitureModel.video),
        ),
      ),
    );
  }
}
