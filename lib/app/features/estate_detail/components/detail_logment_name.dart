import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

class DetailEstateName extends StatelessWidget {
  const DetailEstateName({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(appPadding, 20, appPadding, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type badge ──
            if (bienImmobilier.typeBienImmobilier.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bienImmobilier.typeBienImmobilier,
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
              bienImmobilier.nom,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF222222),
              ),
            ),

            const SizedBox(height: 8),

            // ── Score + Location row ──
            Row(
              children: [
                if (bienImmobilier.score != null) ...[
                  Icon(Iconsax.star1, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    bienImmobilier.score!.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '•',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                  const SizedBox(width: 4),
                ],
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

            const SizedBox(height: 12),

            // ── Price ──
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${CurrencyFormatter().format(bienImmobilier.prix.toString())} Fcfa",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  if (bienImmobilier.typeLocation.isNotEmpty)
                    TextSpan(
                      text: ' /${bienImmobilier.typeLocation}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildLocation() {
    final parts = <String>[];
    if (bienImmobilier.communeModel != null) {
      parts.add(bienImmobilier.communeModel!.name);
    } else if ((bienImmobilier.commune ?? '').isNotEmpty) {
      parts.add(bienImmobilier.commune!);
    }
    if (bienImmobilier.villeModel != null) {
      parts.add(bienImmobilier.villeModel!.name);
    } else if ((bienImmobilier.ville ?? '').isNotEmpty) {
      parts.add(bienImmobilier.ville!);
    }
    return parts.join(', ');
  }
}
