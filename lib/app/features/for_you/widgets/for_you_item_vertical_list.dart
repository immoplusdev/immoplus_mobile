import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/for_you/see_more_page.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_inline_ad_tile.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_vertical_card.dart';

/// Rendu vertical des items d'une section `residence_list`/`bien_list`
/// (ex: pour l'onglet "Trouver un logement", "Acheter un bien", "Séjour").
class ForYouItemVerticalList extends StatelessWidget {
  final HomeFeedSection section;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;

  const ForYouItemVerticalList({
    super.key,
    required this.section,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.itemSpacing = 16.0,
  });

  bool get _isResidence => section.type == HomeFeedSectionType.residenceList;

  @override
  Widget build(BuildContext context) {
    final items = section.listItems;
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeSectionTitle(title: section.title),
          const Gap(14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: items.length + (section.hasSeeMore ? 1 : 0),
            separatorBuilder: (context, index) => Gap(itemSpacing),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return _VerticalSeeMoreButton(
                  title: section.title,
                  seeMoreEndpoint: section.seeMoreEndpoint,
                  isResidence: _isResidence,
                );
              }

              final entry = items[index];
              if (entry.isAd) {
                return ForYouInlineAdTile(campaign: entry.ad!);
              }

              if (!_isResidence) {
                final bien = entry.asBien!;
                return ForYouVerticalCard.fromBien(
                  bien: bien,
                  onTap: () => context.push('/estate_detail/${bien.bienId}'),
                );
              }

              final residence = entry.asResidence!;
              return ForYouVerticalCard.fromResidence(
                residence: residence,
                onTap: () => context.push('/residence_detail/${residence.residenceId}'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _VerticalSeeMoreButton extends StatelessWidget {
  final String title;
  final String? seeMoreEndpoint;
  final bool isResidence;

  const _VerticalSeeMoreButton({
    required this.title,
    required this.seeMoreEndpoint,
    required this.isResidence,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        SeeMorePage.routeName,
        extra: {
          'title': title,
          'seeMoreEndpoint': seeMoreEndpoint,
          'contentType': isResidence
              ? SeeMoreContentType.residence
              : SeeMoreContentType.bien,
        },
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.immoBgSurfaceMuted.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.immoBorderDefault),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Voir plus de $title',
              style: AppTypography.font(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.immoTextLabel,
              ),
            ),
            const Gap(6),
            Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: AppColors.immoTextLabel,
            ),
          ],
        ),
      ),
    );
  }
}
