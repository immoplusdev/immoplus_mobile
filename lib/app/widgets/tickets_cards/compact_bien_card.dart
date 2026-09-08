import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class CompactBienCard extends StatelessWidget {
  const CompactBienCard({
    super.key,
    required this.bien,
  });

  final BienImmobilierModel bien;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: neirResidenceCardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/estate_detail/${bien.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: 170,
                child: _buildBackgroundImage(),
              ),
            ),
            const Gap(8),
            _buildBienInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    final imageUrl = bien.images.isNotEmpty
        ? Utils.getImagePath(id: bien.images.first)
        : '';

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 600,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.grey300,
        highlightColor: AppColors.grey100,
        period: const Duration(milliseconds: 500),
        child: Container(color: AppColors.white),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.grey200,
        child: Center(
          child: Icon(
            FontAwesomeIcons.images.data,
            size: 60,
            color: AppColors.grey400,
          ),
        ),
      ),
    );
  }

  Widget _buildBienInfo(BuildContext context) {
    final location = bien.communeModel?.name ??
        bien.villeModel?.name ??
        bien.adresse;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          bien.nom,
          style: AppTypography.button.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(3),
        Text(
          location,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.grey600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${CurrencyFormatter().format(bien.prix.toString())} Fcfa',
                style: AppTypography.button.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                ),
              ),
              if (bien.aLouer)
                TextSpan(
                  text: '/mois',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
