import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/video_player/video_player_page.dart';

class DetailEstateVideo extends StatelessWidget {
  const DetailEstateVideo({
    super.key,
    required this.bienImmobilier,
  });
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible:
          (bienImmobilier.video != null) && bienImmobilier.video!.isNotEmpty,
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
        child: VideoPlayerPage(videoID: bienImmobilier.video ?? ''),
      )),
    );
  }
}
