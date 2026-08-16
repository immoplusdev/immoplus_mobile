import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';

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

    return AdTap(
      campaign: campaign,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[100]!,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 380,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 380,
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
