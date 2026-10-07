import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class CompactFurnitureCard extends StatelessWidget {
  const CompactFurnitureCard({
    super.key,
    required this.furniture,
  });

  final FurnitureModel furniture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: neirResidenceCardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Constantes.tempPage = Utils.getCurrentLocation();
          context.push(
            FurnitureDetailPage.route(furniture.id),
            extra: furniture,
          );
        },
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
            _buildFurnitureInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    final imageUrl = furniture.images.isNotEmpty
        ? Utils.getImagePath(id: furniture.images.first)
        : '';

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 600,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.gray300,
        highlightColor: AppColors.gray100,
        period: const Duration(milliseconds: 500),
        child: Container(color: AppColors.white),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.gray200,
        child: Center(
          child: Icon(
            FontAwesomeIcons.images.data,
            size: 60,
            color: AppColors.gray400,
          ),
        ),
      ),
    );
  }

  Widget _buildFurnitureInfo(BuildContext context) {
    final location = furniture.communeModel?.name ??
        furniture.villeModel?.name ??
        furniture.adresse;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          furniture.titre,
          style: AppTypography.button.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.gray950,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(3),
        Text(
          location,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.gray500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(12),
        Text(
          '${CurrencyFormatter().format(furniture.prix.toString())} Fcfa',
          style: AppTypography.button.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
