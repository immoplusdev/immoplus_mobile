import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_ad_banner.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_bien_groups_section.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_item_carousel.dart';
import 'package:immoplus/app/features/for_you/widgets/poll_banner_card.dart';

/// Dispatche une entrée de `sections[]` vers le widget adapté à son `type`.
/// Une section vide est masquée entièrement (voir `HomeFeedSection.isEmpty`
/// et HOME FEED AGREGATOR.MD § 6).
class ForYouSectionView extends StatelessWidget {
  final HomeFeedSection section;

  const ForYouSectionView({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    if (section.isEmpty) return const SizedBox.shrink();

    switch (section.type) {
      case HomeFeedSectionType.residenceList:
      case HomeFeedSectionType.bienList:
        return ForYouItemCarousel(section: section);
      case HomeFeedSectionType.bienGroupsByLocation:
        return ForYouBienGroupsSection(section: section);
      case HomeFeedSectionType.adBanner:
        return ForYouAdBanner(section: section);
      case HomeFeedSectionType.pollBanner:
        return PollBannerCard(
          key: ValueKey(section.poll!.pollId),
          poll: section.poll!,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
