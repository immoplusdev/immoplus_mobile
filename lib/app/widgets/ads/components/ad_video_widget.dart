import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/ad_action_handler.dart';
import 'package:immoplus/app/features/video_player/video_player_page.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';

class AdVideoWidget extends StatelessWidget {
  final AdCampaignModel campaign;

  const AdVideoWidget({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final videoId =
        campaign.media.videos.isNotEmpty ? campaign.media.videos.first : '';

    return AdTap(
      campaign: campaign,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xffE1E6FF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: VideoPlayerPage(
                  videoID: videoId,
                  buildErrorWidget: (retry) => Center(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Impossible de lire la vidéo"),
                          TextButton(
                            onPressed: retry,
                            child: Text("Appuyer pour réessayer"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Info + CTA section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (campaign.content.badge?.isNotEmpty == true) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2548E5)
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              campaign.content.badge!,
                              style: GoogleFonts.dmSans(
                                color: const Color(0xFF2548E5),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Gap(6),
                        ],
                        Text(
                          campaign.content.title ?? '',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF222222),
                          ),
                        ),
                        if (campaign.content.subtitle?.isNotEmpty == true) ...[
                          const Gap(2),
                          Text(
                            campaign.content.subtitle!,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // CTA button
                  if (campaign.content.ctaLabel?.isNotEmpty == true) ...[
                    const Gap(12),
                    ElevatedButton(
                      onPressed: () =>
                          AdActionHandler.handleAdAction(context, campaign),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2548E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      child: Text(
                        campaign.content.ctaLabel!,
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
