import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/enums/analytics/residence_entry_point.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/home_feed/for_you_residence_item.dart';
import 'package:immoplus/app/design_system/design_system.dart';
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

  bool get _hasAdvanceNotice =>
      residence.advanceNoticeDays != null && residence.advanceNoticeDays! > 0;

  bool get _hasWeekendPrice =>
      residence.weekendNightlyPrice != null &&
      residence.weekendNightlyPrice! > 0;

  String get _advanceNoticeLabel {
    final days = residence.advanceNoticeDays;
    return days == 1
        ? 'Réserver au moins 1 jour en avance.'
        : 'Réserver au moins $days jours en avance.';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: neirResidenceCardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(ResidencePage.route(
          residence.residenceId,
          entryPoint: ResidenceEntryPoint.homeFeed,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: 170,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(),
                    if (_hasAdvanceNotice)
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: _buildAdvanceNoticeBadge(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Gap(8),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvanceNoticeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Iconsax.calendar_1,
            size: 11,
            color: AppColors.black,
          ),
          const Gap(4),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _advanceNoticeLabel,
                maxLines: 1,
                style: AppTypography.font(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = residence.imageUrl != null
        ? Utils.getImagePath(id: residence.imageUrl!)
        : '';
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
          child: FaIcon(FontAwesomeIcons.images,
              size: 60, color: AppColors.immoTextDisabled),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    final displayCurrency = residence.currency ?? 'XOF';

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
            style: AppTypography.font(
                color: AppColors.immoTextSecondary, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const Gap(8),
        if (_hasWeekendPrice && residence.isWeekend) ...[
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Week-end · ${CurrencyFormatter().format(residence.weekendNightlyPrice.toString())} $displayCurrency',
                    style: AppTypography.font(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' / nuit',
                    style: AppTypography.font(
                      color: AppColors.immoTextSecondary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (residence.pricePerNight != null) ...[
            const Gap(2),
            Text(
              '${CurrencyFormatter().format(residence.pricePerNight.toString())} $displayCurrency / nuit',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.font(
                color: AppColors.immoTextSecondary,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ] else if (_hasWeekendPrice && !residence.isWeekend) ...[
          if (residence.pricePerNight != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${CurrencyFormatter().format(residence.pricePerNight.toString())} $displayCurrency',
                    style: AppTypography.font(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' / nuit',
                    style: AppTypography.font(
                      color: AppColors.immoTextSecondary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          const Gap(2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Week-end · ${CurrencyFormatter().format(residence.weekendNightlyPrice.toString())} $displayCurrency / nuit',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.font(
                color: AppColors.immoTextSecondary,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ] else if (residence.pricePerNight != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${CurrencyFormatter().format(residence.pricePerNight.toString())} $displayCurrency',
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
