import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/widgets/ads/resolved_ad_card.dart';

/// Rendu d'une section `ad_banner` : une pub à part entière, en pleine
/// largeur, à sa position exacte dans `sections[]` (`section_position:
/// "before"/"after"` sur la pub cible l'ordre côté backend, le front n'a
/// qu'à respecter l'ordre du tableau).
class ForYouAdBanner extends StatelessWidget {
  final HomeFeedSection section;

  const ForYouAdBanner({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final ad = section.ad;
    if (ad == null) return const SizedBox.shrink();
    return ResolvedAdCard(campaign: ad);
  }
}
