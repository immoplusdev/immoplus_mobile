import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';

/// Pub `itemType: "ad"` interleavée par le backend entre deux items d'un
/// carousel (`section_position: "inline"`) — au gabarit d'une carte du
/// carousel, contrairement à `ResolvedAdCard`/`buildAdCampaignLayout` qui
/// rendent en pleine largeur (utilisés pour `ad_banner`).
class ForYouInlineAdTile extends StatelessWidget {
  final AdCampaignModel campaign;

  const ForYouInlineAdTile({super.key, required this.campaign});

  static const double _width = 122;
  static const double _height = 163;

  @override
  Widget build(BuildContext context) {
    final imageUrl = campaign.media.images.isNotEmpty
        ? Utils.getImagePath(id: campaign.media.images.first)
        : '';

    return VisibilityDetector(
      key: ValueKey('inline_ad_detector_${campaign.id}_${campaign.placement}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          context.read<AdsCubit>().trackImpression(campaign.id, campaign.placement);
        }
      },
      child: AdTap(
        campaign: campaign,
        // La liste horizontale impose une hauteur de ligne (cross axis)
        // tight, souvent > `_height` : `Align` empêche cette contrainte de
        // "gonfler" la carte (à la différence d'un `SizedBox` seul, qui
        // serait forcé à la hauteur de la ligne).
        child: Align(
          alignment: Alignment.topLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: _width,
              height: _height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.55)],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (campaign.content.title != null)
                          Text(
                            campaign.content.title!,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (campaign.content.subtitle != null) ...[
                          const Gap(2),
                          Text(
                            campaign.content.subtitle!,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 8,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
