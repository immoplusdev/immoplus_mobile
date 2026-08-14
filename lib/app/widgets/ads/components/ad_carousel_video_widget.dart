import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';
import 'package:immoplus/app/widgets/ads/components/ad_video_cover_widget.dart';

class AdCarouselVideoWidget extends StatefulWidget {
  final AdCampaignModel campaign;

  const AdCarouselVideoWidget({
    super.key,
    required this.campaign,
  });

  @override
  State<AdCarouselVideoWidget> createState() => _AdCarouselVideoWidgetState();
}

class _AdCarouselVideoWidgetState extends State<AdCarouselVideoWidget> {
  @override
  Widget build(BuildContext context) {
    final videos = widget.campaign.media.videos;
    if (videos.isEmpty) return const SizedBox.shrink();

    return AdTap(
      campaign: widget.campaign,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          if (widget.campaign.content.title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                widget.campaign.content.title!,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.2,
                ),
              ),
            ),

          // Horizontal ListView for videos (matching UI: portrait aspect ratio, overlaid text)
          SizedBox(
            height: 163,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: 122,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AdVideoCoverWidget(
                        videoID: videos[index],
                        buildErrorWidget: (retry) => _ErrorCard(onRetry: retry),
                      ),

                      // Gradient and Text Overlay
                      // Positioned(
                      //   bottom: 0,
                      //   left: 0,
                      //   right: 0,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(16),
                      //     decoration: BoxDecoration(
                      //       gradient: LinearGradient(
                      //         begin: Alignment.bottomCenter,
                      //         end: Alignment.topCenter,
                      //         colors: [
                      //           Colors.black.withValues(alpha: 0.8),
                      //           Colors.transparent,
                      //         ],
                      //       ),
                      //     ),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           widget.campaign.content.title ?? '',
                      //           style: GoogleFonts.dmSans(
                      //             color: Colors.white,
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         const SizedBox(height: 4),
                      //         if (widget
                      //                 .campaign.content.subtitle?.isNotEmpty ==
                      //             true)
                      //           Text(
                      //             widget.campaign.content.subtitle!,
                      //             style: GoogleFonts.dmSans(
                      //               color: Colors.white.withValues(alpha: 0.8),
                      //               fontSize: 15,
                      //             ),
                      //           ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Compact error state shown inside each video card
class _ErrorCard extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: EdgeInsets.all(2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off, size: 36, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Impossible de lire la vidéo',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Réessayer',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2548E5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
