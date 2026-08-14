import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:immoplus/app/data/enums/ad_placement.dart';
import 'package:immoplus/app/data/enums/ad_type.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/logic/ads/ads_state.dart';
import 'components/ad_carousel_video_widget.dart';
import 'components/ad_carousel_widget.dart';
import 'components/ad_image_widget.dart';
import 'components/ad_video_widget.dart';

class AdWidget extends StatelessWidget {
  final AdPlacement placement;
  final int? index; // Optional position within list/grid

  const AdWidget({
    super.key,
    required this.placement,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsCubit, AdsState>(
      builder: (context, state) {
        return state.maybeWhen(
          success: (campaigns) {
            // Filter campaigns matching this placement
            final placementCampaigns =
                campaigns.where((c) => c.placement == placement.value).toList();

            if (placementCampaigns.isEmpty) {
              return const SizedBox.shrink();
            }

            // Sort by priority desc
            placementCampaigns.sort((a, b) => b.priority.compareTo(a.priority));

            // Select the active campaign. If list placement, match by positionIndex if specified.
            final AdCampaignModel selectedCampaign;
            if (index != null) {
              final matchedIndex = placementCampaigns
                  .where((c) => c.positionIndex == index)
                  .toList();
              if (matchedIndex.isNotEmpty) {
                selectedCampaign = matchedIndex.first;
              } else {
                return const SizedBox.shrink();
              }
            } else {
              selectedCampaign = placementCampaigns.first;
            }

            return VisibilityDetector(
              key: ValueKey(
                  'ad_detector_${selectedCampaign.id}_${placement.value}'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.5) {
                  context.read<AdsCubit>().trackImpression(
                        selectedCampaign.id,
                        placement.value,
                      );
                }
              },
              child: _buildAdLayout(selectedCampaign),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildAdLayout(AdCampaignModel campaign) {
    switch (AdType.fromString(campaign.type)) {
      case AdType.carousel:
        return AdCarouselWidget(campaign: campaign);
      case AdType.video:
        return AdVideoWidget(campaign: campaign);
      case AdType.videoCarousel:
        return AdCarouselVideoWidget(campaign: campaign);
      case AdType.image:
        return AdImageWidget(campaign: campaign);
    }
  }
}
