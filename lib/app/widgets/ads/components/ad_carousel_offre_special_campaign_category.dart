import 'package:flutter/material.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';
import 'package:immoplus/app/widgets/image_collage.dart';

class AdCarouselOffreSpecialCampaignCategory extends StatelessWidget {
  final AdCampaignModel campaign;

  const AdCarouselOffreSpecialCampaignCategory({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final images = campaign.media.images;
    final badge = campaign.content.badge;
    final title = campaign.content.title;
    final subtitle = campaign.content.subtitle;
    final ctaLabel = campaign.content.ctaLabel;

    return AdTap(
      campaign: campaign,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header (Badge or category header)
            if (badge?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  badge!,
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textNavyDeep,
                    letterSpacing: -0.4,
                  ),
                ),
              ),

            // Content Row: ImageCollage (left) + Info details (right)
            LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final leftWidth = totalWidth * 0.52;
                const collageHeight = 190.0;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Collage d'images
                    ImageCollage(
                      images: images,
                      width: leftWidth,
                      height: collageHeight,
                      borderRadius: 16,
                      spacing: 4,
                    ),
                    const SizedBox(width: 14),

                    // Détails à droite
                    Expanded(
                      child: SizedBox(
                        height: collageHeight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (title?.isNotEmpty == true)
                                  Text(
                                    title!,
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimaryDark,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (subtitle?.isNotEmpty == true) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle!,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textLightGray,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),

                            // Bouton CTA uniquement si fourni
                            if (ctaLabel?.isNotEmpty == true)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    ctaLabel!,
                                    style: AppTypography.labelMedium.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
