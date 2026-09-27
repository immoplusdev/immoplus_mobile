import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'ad_widget.dart';

/// Pub déjà résolue par le backend (ex: `itemType: "ad"` dans une section
/// `residence_list`, ou le champ `ad` d'une section `ad_banner`) — contrairement
/// à `AdWidget`, ne refait pas de fetch/matching par placement : la campagne
/// à afficher est déjà connue, on ne fait que le rendu + le tracking.
class ResolvedAdCard extends StatelessWidget {
  final AdCampaignModel campaign;

  const ResolvedAdCard({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey('resolved_ad_detector_${campaign.id}_${campaign.placement}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          context.read<AdsCubit>().trackImpression(
                campaign.id,
                campaign.placement,
              );
        }
      },
      child: buildAdCampaignLayout(campaign),
    );
  }
}
