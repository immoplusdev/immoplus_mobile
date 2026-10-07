import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class RecommendationForYouTile extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;

  const RecommendationForYouTile({
    super.key,
    required this.item,
    required this.onTap,
  }) : assert(item is ResidenceModel || item is BienImmobilierModel);

  String get name => switch (item) {
        ResidenceModel r => r.nom,
        BienImmobilierModel b => b.nom,
        _ => '',
      };

  List<String> get images {
    final rawList = switch (item) {
      ResidenceModel r => r.images,
      BienImmobilierModel b => b.images,
      _ => <String>[],
    };
    return rawList.where((img) {
      final s = img.trim().toLowerCase();
      return s.isNotEmpty && s != 'string' && s != 'null' && s != 'undefined';
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = images.isNotEmpty;
    final dotColor = hasImage ? AppColors.immoTextDisabled : AppColors.primary;
    final textColor = hasImage ? AppColors.black87 : AppColors.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Text(
                name,
                style: AppTypography.font(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Gap(12),
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: Utils.getImagePath(id: images.first),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 40,
                    height: 40,
                    color: AppColors.immoBorderDefault,
                    child: Icon(Icons.image_not_supported,
                        size: 20, color: AppColors.immoTextSecondary),
                  ),
                ),
              )
            else
              Icon(Icons.search, color: AppColors.immoBorderStrong, size: 24),
          ],
        ),
      ),
    );
  }
}
