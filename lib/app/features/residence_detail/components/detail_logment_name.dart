import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class DetailLogmentName extends StatelessWidget {
  const DetailLogmentName({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(appPadding, 20, appPadding, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type badge ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                residenceModel.typeResidence,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Name ──
            Text(
              residenceModel.nom.capitalizeWords(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF222222),
                // letterSpacing: -0.5,
                // height: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            // ── Rating + Location row ──
            Row(
              children: [
                // Score
                if (residenceModel.score != null) ...[
                  Icon(Iconsax.star1, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    residenceModel.score!.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                // Location
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _buildLocation(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildLocation() {
    final parts = <String>[];
    if (residenceModel.communeModel != null) {
      parts.add(residenceModel.communeModel!.name);
    } else if (residenceModel.commune.isNotEmpty) {
      parts.add(residenceModel.commune);
    }
    if (residenceModel.villeModel != null) {
      parts.add(residenceModel.villeModel!.name);
    } else if (residenceModel.ville.isNotEmpty) {
      parts.add(residenceModel.ville);
    }
    return parts.join(', ');
  }
}