import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';
import 'package:immoplus/app/widgets/ads/components/ad_video_cover_widget.dart';

class AdCarouselVideoWidget extends StatelessWidget {
  final AdCampaignModel campaign;

  const AdCarouselVideoWidget({
    super.key,
    required this.campaign,
  });

  void _openInFeed(BuildContext context, int index) {
    final entityIds = campaign.scope?.entityIds ?? const [];
    final baseUrl = campaign.url;
    if (baseUrl == null || baseUrl.isEmpty || index >= entityIds.length) {
      return;
    }
    context.read<AdsCubit>().trackClick(campaign.id, campaign.placement);
    context.push('$baseUrl/${entityIds[index]}');
  }

  @override
  Widget build(BuildContext context) {
    final videoIds = campaign.scope?.entityIds ?? const [];
    if (videoIds.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        if (campaign.content.title?.isNotEmpty == true)
          AdTap(
            campaign: campaign,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                campaign.content.title!,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),

        // Horizontal ListView for videos (matching UI: portrait aspect ratio, overlaid text)
        SizedBox(
          height: 163,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: videoIds.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 122,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: AdVideoCoverWidget(
                  videoId: videoIds[index],
                  onTap: () => _openInFeed(context, index),
                  buildErrorWidget: (retry) => _ErrorCard(onRetry: retry),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
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
