import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_list_item.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/features/for_you/see_more_page.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Rendu d'une section `bien_groups_by_location` (ex: "Biens à louer par
/// commune") : UNE section, avec un carousel horizontal de cartes
/// commune/ville — pas une section par lieu (voir HOME FEED AGREGATOR.MD
/// § 4, ce qu'il ne faut pas faire). Chaque carte est une tuile
/// destination (photo + nom + nombre de biens), pas un mini-carousel de
/// biens individuels.
class ForYouBienGroupsSection extends StatelessWidget {
  final HomeFeedSection section;

  const ForYouBienGroupsSection({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final groups = section.locationGroups;
    if (groups.isEmpty) return const SizedBox.shrink();

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
          height: _LocationGroupCard.height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: groups.length,
            separatorBuilder: (context, index) => const Gap(18),
            itemBuilder: (context, index) =>
                _LocationGroupCard(group: groups[index]),
          ),
        ),
      ],
    );
  }
}

class _LocationGroupCard extends StatelessWidget {
  final BienLocationGroup group;

  const _LocationGroupCard({required this.group});

  static const double width = 122;
  static const double height = 163;

  /// Le backend ne fournit pas d'image dédiée à la commune/ville : on
  /// utilise la photo du premier bien du groupe comme visuel de la carte.
  String? get _coverImageId {
    for (final entry in group.items) {
      if (entry.isAd) continue;
      final imageUrl = entry.asBien?.imageUrl;
      if (imageUrl != null) return imageUrl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final coverImageId = _coverImageId;

    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: group.seeMoreEndpoint == null
            ? null
            : () => context.pushNamed(
                  SeeMorePage.routeName,
                  extra: {
                    'title': group.locationName,
                    'seeMoreEndpoint': group.seeMoreEndpoint,
                    'contentType': SeeMoreContentType.bien,
                  },
                ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              coverImageId != null
                  ? CachedNetworkImage(
                      imageUrl: Utils.getImagePath(id: coverImageId),
                      fit: BoxFit.cover,
                      memCacheWidth: 300,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.immoBorderStrong,
                        highlightColor: AppColors.immoBgSurfaceMuted,
                        period: const Duration(milliseconds: 500),
                        child: Container(color: AppColors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.immoBorderStrong,
                        child: FaIcon(
                          FontAwesomeIcons.images,
                          size: 28,
                          color: AppColors.immoTextSecondary,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.immoBorderStrong,
                      child: FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 28,
                        color: AppColors.immoTextSecondary,
                      ),
                    ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.45, 1.0],
                    colors: [
                      AppColors.transparent,
                      AppColors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      group.locationName,
                      style: AppTypography.font(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(1),
                    Text(
                      '${group.itemCount} biens',
                      style: AppTypography.font(
                        fontWeight: FontWeight.w500,
                        fontSize: 8,
                        color: const Color(0xFFCECECE),
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
