import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/home_feed/for_you_bien_item.dart';
import 'package:immoplus/app/data/models/remote/home_feed/for_you_residence_item.dart';
import 'package:immoplus/app/data/models/remote/home_feed/property_badge_dto.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Carte verticale pour l'affichage en liste (ex: "Trouver un logement", "Acheter un bien")
/// Affiche la grande image avec coins arrondis, titre, chips, badge VIP/Nouveau,
/// prix en gras et description.
class ForYouVerticalCard extends StatelessWidget {
  final String id;
  final String title;
  final String? imageUrl;
  final String? location;
  final int? price;
  final String? currency;
  final bool isRent;
  final String? description;
  final List<String> chips;
  final PropertyBadgeDto? badge;
  final VoidCallback? onTap;

  const ForYouVerticalCard({
    super.key,
    required this.id,
    required this.title,
    this.imageUrl,
    this.location,
    this.price,
    this.currency,
    this.isRent = false,
    this.description,
    this.chips = const [],
    this.badge,
    this.onTap,
  });

  factory ForYouVerticalCard.fromBien({
    Key? key,
    required ForYouBienItem bien,
    VoidCallback? onTap,
  }) {
    final computedChips = <String>[];
    if (bien.chips.isNotEmpty) {
      computedChips.addAll(bien.chips);
    } else {
      if (bien.location != null && bien.location!.isNotEmpty) {
        computedChips.add(bien.location!);
      }
      if (bien.typeBienImmobilier != null && bien.typeBienImmobilier!.isNotEmpty) {
        computedChips.add(bien.typeBienImmobilier!);
      }
    }

    return ForYouVerticalCard(
      key: key,
      id: bien.bienId,
      title: bien.name,
      imageUrl: bien.imageUrl,
      location: bien.location,
      price: bien.price,
      currency: bien.currency ?? 'FCFA',
      isRent: bien.aLouer,
      description: bien.description,
      chips: computedChips,
      badge: bien.badge,
      onTap: onTap,
    );
  }

  factory ForYouVerticalCard.fromResidence({
    Key? key,
    required ForYouResidenceItem residence,
    VoidCallback? onTap,
  }) {
    final computedChips = <String>[];
    if (residence.chips.isNotEmpty) {
      computedChips.addAll(residence.chips);
    } else {
      if (residence.location != null && residence.location!.isNotEmpty) {
        computedChips.add(residence.location!);
      }
    }

    return ForYouVerticalCard(
      key: key,
      id: residence.residenceId,
      title: residence.name,
      imageUrl: residence.imageUrl,
      location: residence.location,
      price: residence.pricePerNight,
      currency: residence.currency ?? 'FCFA',
      isRent: true,
      description: residence.description,
      chips: computedChips,
      badge: residence.badge,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.immoBorderDefault, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap ??
              () {
                context.push('/estate_detail/$id');
              },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImage(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    const Gap(8),
                    _buildChipsAndBadge(),
                    if (price != null) ...[
                      const Gap(8),
                      _buildPrice(),
                    ],
                    if (description != null && description!.trim().isNotEmpty) ...[
                      const Gap(6),
                      _buildDescription(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final formattedUrl = (imageUrl != null && imageUrl!.isNotEmpty)
        ? Utils.getImagePath(id: imageUrl!)
        : '';

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: CachedNetworkImage(
          imageUrl: formattedUrl,
          fit: BoxFit.cover,
          memCacheWidth: 800,
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
              child: FaIcon(
                FontAwesomeIcons.images,
                size: 50,
                color: AppColors.immoTextDisabled,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: AppTypography.font(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: AppColors.black,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildChipsAndBadge() {
    final hasChips = chips.isNotEmpty;
    final hasBadge = badge != null && badge!.label.isNotEmpty;

    if (!hasChips && !hasBadge) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...chips.map((chipText) => _buildChip(chipText)),
        if (hasBadge) _buildBadge(badge!),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.immoBorderDefault, width: 1.0),
      ),
      child: Text(
        label,
        style: AppTypography.font(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.black87,
        ),
      ),
    );
  }

  Widget _buildBadge(PropertyBadgeDto badgeDto) {
    final isVip = badgeDto.tier.toLowerCase() == 'vip';
    final borderColor = isVip ? const Color(0xFFE5A93C) : AppColors.primary;
    final textColor = isVip ? const Color(0xFFD97706) : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isVip ? const Color(0xFFFFFBEB) : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Text(
        badgeDto.label,
        style: AppTypography.font(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildPrice() {
    final formattedPrice = CurrencyFormatter().format(price.toString());
    final displayCurrency = currency ?? 'FCFA';

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$formattedPrice $displayCurrency',
            style: AppTypography.font(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: AppColors.black,
            ),
          ),
          if (isRent)
            TextSpan(
              text: ' /mois',
              style: AppTypography.font(
                color: AppColors.immoTextSecondary,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      description!,
      style: AppTypography.font(
        color: AppColors.immoTextSecondary,
        fontSize: 13,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
