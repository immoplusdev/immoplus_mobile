import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/features/for_you/see_more_page.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_bien_tile.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_inline_ad_tile.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_residence_tile.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_top_rated_tile.dart';
import 'package:immoplus/app/widgets/animated_photo_stack_icon.dart';

/// Rendu d'une section `residence_list`/`bien_list` : un carousel horizontal
/// mélangeant les items (résidence ou bien selon `section.type`) et les pubs
/// interleavées par le backend (`itemType: "ad"`, déjà positionnées).
class ForYouItemCarousel extends StatelessWidget {
  final HomeFeedSection section;

  const ForYouItemCarousel({super.key, required this.section});

  bool get _isResidence => section.type == HomeFeedSectionType.residenceList;

  /// "Les plus aimées" a un gabarit dédié (photo pleine largeur + avatars
  /// des reviewers) au lieu de la carte compacte classique.
  bool get _isTopRated => section.key == HomeFeedSectionType.topRatedKey;

  @override
  Widget build(BuildContext context) {
    final items = section.listItems;
    if (items.isEmpty) return const SizedBox.shrink();

    // "Les plus aimées" a de la marge en plus : la pile d'avatars déborde
    // volontairement hors de la carte (coin bas-droite) et ne doit pas être
    // rognée par le viewport de la ListView.
    final cardHeight = _isTopRated
        ? ForYouTopRatedTile.height + ForYouTopRatedTile.overflowAllowance
        : compactResidenceCardHeight;
    final cardGap = _isTopRated ? 12.0 : 18.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: HomeSectionTitle(title: section.title),
        ),
        const Gap(12),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length + (section.hasSeeMore ? 1 : 0),
            separatorBuilder: (context, index) => Gap(cardGap),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return _SeeMoreTile(
                  height: cardHeight,
                  onTap: () => context.pushNamed(
                    SeeMorePage.routeName,
                    extra: {
                      'title': section.title,
                      'seeMoreEndpoint': section.seeMoreEndpoint,
                      'contentType': _isResidence
                          ? SeeMoreContentType.residence
                          : SeeMoreContentType.bien,
                    },
                  ),
                );
              }
              final entry = items[index];
              if (entry.isAd) {
                return ForYouInlineAdTile(campaign: entry.ad!);
              }
              if (!_isResidence) {
                return ForYouBienTile(bien: entry.asBien!);
              }
              if (!_isTopRated) {
                return ForYouResidenceTile(residence: entry.asResidence!);
              }
              // `Align` (pas juste `SizedBox`) : la ligne fait 286+30, mais
              // la carte doit rester 286 et se caler en haut — sinon la
              // hauteur "tight" imposée par la ListView l'étire.
              return Align(
                alignment: Alignment.topLeft,
                child: ForYouTopRatedTile(residence: entry.asResidence!),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Carte "Voir plus" en fin de carrousel — remplace l'ancienne flèche dans
/// l'en-tête de section : l'icône animée en éventail (partagée avec
/// `TransactionsFloatingButton`) tourne en continu pour attirer l'œil sans
/// avoir besoin d'un texte d'appel supplémentaire.
class _SeeMoreTile extends StatelessWidget {
  final double height;
  final VoidCallback onTap;

  const _SeeMoreTile({required this.height, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: neirResidenceCardWidth,
      height: height,
      child: Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: neirResidenceCardWidth,
            // Même hauteur que la zone image d'une carte résidence (170) —
            // pas la carte entière (image + infos), pour rester au même
            // niveau visuel que les vraies cartes du carousel.
            height: 170,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade100.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AnimatedPhotoStackIcon(size: 56),
                const Gap(14),
                Text(
                  'Voir plus',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
