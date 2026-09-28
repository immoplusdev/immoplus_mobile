import 'package:immoplus/app/design_system/design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/home_feed/for_you_residence_item.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Carte résidence pour les carousels de la home agrégée (`GET /me/home`) —
/// même gabarit visuel que `CompactResidenceCard`, mais construite à partir
/// du résumé léger `ForYouResidenceItem` plutôt que du `ResidenceModel`
/// complet (la fiche détail se charge par id via `ResidencePage`).
class ForYouResidenceTile extends StatelessWidget {
  final ForYouResidenceItem residence;

  const ForYouResidenceTile({super.key, required this.residence});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: neirResidenceCardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(ResidencePage.route(residence.residenceId)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: 170,
                child: _buildImage(),
              ),
            ),
            const Gap(8),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl =
        residence.imageUrl != null ? Utils.getImagePath(id: residence.imageUrl!) : '';
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 600,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.immoBorderStrong,
        highlightColor: AppColors.immoBgSurfaceMuted,
        period: const Duration(milliseconds: 500),
        child: Container(color: AppColors.white),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.immoBorderDefault,
        child: Center(
          child: FaIcon(FontAwesomeIcons.images, size: 60, color: AppColors.immoTextDisabled),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          residence.name,
          style: AppTypography.font(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (residence.location != null) ...[
          const Gap(3),
          Text(
            residence.location!,
            style: AppTypography.font(color: AppColors.immoTextSecondary, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const Gap(12),
        if (residence.pricePerNight != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${CurrencyFormatter().format(residence.pricePerNight.toString())} ${residence.currency ?? "Fcfa"}',
                  style: AppTypography.font(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: '/nuit',
                  style: AppTypography.font(
                    color: AppColors.immoTextSecondary,
                    fontWeight: FontWeight.w200,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
