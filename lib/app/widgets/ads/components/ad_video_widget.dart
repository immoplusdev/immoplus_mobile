import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/features/prop_feed/video_repository.dart';
import 'package:immoplus/app/utils/ad_action_handler.dart';
import 'package:immoplus/app/features/video_player/video_player_page.dart';
import 'package:immoplus/app/utils/PromoCarrousel/promo_carousel_card.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';

class AdVideoWidget extends StatefulWidget {
  final AdCampaignModel campaign;

  const AdVideoWidget({
    super.key,
    required this.campaign,
  });

  @override
  State<AdVideoWidget> createState() => _AdVideoWidgetState();
}

class _AdVideoWidgetState extends State<AdVideoWidget> {
  final VideoRepository _repository = VideoRepository();
  String? _playbackUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final videoId = widget.campaign.scope?.entityId;
    if (videoId == null || videoId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final video = await _repository.fetchVideoDetail(videoId);
    if (!mounted) return;
    setState(() {
      _playbackUrl = video?.playbackUrl;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    if (_isLoading) {
      return const AspectRatio(
        aspectRatio: 16 / 8.5,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_playbackUrl == null || _playbackUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    return AdTap(
      campaign: campaign,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          final bleed = (screenWidth - constraints.maxWidth) / 2;

          return Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: -bleed, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video section
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 8.5,
                      child: VideoPlayerPage(
                        videoID: campaign.scope?.entityId ?? '',
                        videoUrl: _playbackUrl,
                        autoPlay: true,
                        looping: true,
                        muted: true,
                        showControls: false,
                        buildErrorWidget: (retry) => Center(
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
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Ads',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF222222),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Info + CTA section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  color: kPrimaryColor.withValues(alpha: 0.08),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (campaign.content.badge?.isNotEmpty ==
                                true) ...[
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
                            if (campaign.content.subtitle?.isNotEmpty ==
                                true) ...[
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
                          onPressed: () => AdActionHandler.handleAdAction(
                              context, campaign),
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
          );
        },
      ),
    );
  }
}
