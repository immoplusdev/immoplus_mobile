import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/ad_action_handler.dart';
import 'package:immoplus/app/utils/utils.dart';

class _Constants {
  static const double borderRadius = 20.0;
  static const double badgeRadius = 6.0;
  static const double shadowBlurRadius = 16.0;
  static const double shadowOffsetY = 4.0;
  static const double imageAspectRatio = 16 / 9;
  static const double badgePaddingHorizontal = 8.0;
  static const double badgePaddingVertical = 4.0;
  static const double titleFontSize = 15.0;
  static const double subtitleFontSize = 12.0;
  static const double badgeFontSize = 10.0;
  static const double ctaFontSize = 12.0;

  static const Color primaryBlue = Color(0xFF2548E5);
  static const Color darkText = Color(0xFF222222);
}

class AdImageWidget extends StatelessWidget {
  final AdCampaignModel campaign;

  const AdImageWidget({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final mediaId =
        campaign.media.images.isNotEmpty ? campaign.media.images.first : '';
    final imageUrl = Utils.getImagePath(id: mediaId);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_Constants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: _Constants.shadowBlurRadius,
            offset: const Offset(0, _Constants.shadowOffsetY),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_Constants.borderRadius),
        child: InkWell(
          onTap: () => AdActionHandler.handleAdAction(context, campaign),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: _Constants.imageAspectRatio,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.white,
                    child: Container(color: Colors.grey),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 48, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (campaign.content.badge != null &&
                              campaign.content.badge!.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _Constants.badgePaddingHorizontal,
                                vertical: _Constants.badgePaddingVertical,
                              ),
                              decoration: BoxDecoration(
                                color: _Constants.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    _Constants.badgeRadius),
                              ),
                              child: Text(
                                campaign.content.badge!,
                                style: GoogleFonts.dmSans(
                                  color: _Constants.primaryBlue,
                                  fontSize: _Constants.badgeFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Gap(6),
                          ],
                          Text(
                            campaign.content.title ?? '',
                            style: GoogleFonts.dmSans(
                              fontSize: _Constants.titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: _Constants.darkText,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            campaign.content.subtitle ?? '',
                            style: GoogleFonts.dmSans(
                              fontSize: _Constants.subtitleFontSize,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Gap(12),
                    if (campaign.content.ctaLabel != null &&
                        campaign.content.ctaLabel!.isNotEmpty)
                      ElevatedButton(
                        onPressed: () =>
                            AdActionHandler.handleAdAction(context, campaign),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _Constants.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          campaign.content.ctaLabel!,
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: _Constants.ctaFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
