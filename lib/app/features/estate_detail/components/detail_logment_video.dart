import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
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
    if (bienImmobilier.video == null || bienImmobilier.video!.isEmpty) {
      return const SliverToBoxAdapter();
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visite vidéo',
              style: AppTypography.font(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: AppColors.immoTextPrimary,
              ),
            ),
            SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: AppColors.black,
                  child: VideoPlayerPage(videoID: bienImmobilier.video!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
