import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/design_system/design_system.dart';

class HotelDetailHeader extends StatelessWidget {
  final String title;
  final String? location;
  final bool hasFreeCancellation;
  final String? price;
  final double rating;
  final int commentCount;
  final String? description;

  const HotelDetailHeader({
    super.key,
    required this.title,
    this.location,
    this.hasFreeCancellation = false,
    this.price,
    required this.rating,
    required this.commentCount,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.font(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          
          // Location (For Hotel)
          if (location != null && location!.isNotEmpty) ...[
            const Gap(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.red),
                const Gap(4),
                Flexible(
                  child: Text(
                    location!,
                    textAlign: TextAlign.center,
                    style: AppTypography.font(
                      color: AppColors.immoTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Free Cancellation Tag (For Hotel)
          if (hasFreeCancellation) ...[
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.immoBorderStrong),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Annulation gratuite",
                style: AppTypography.font(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],

          // Description (For Room - below title, for Hotel - bottom. We'll follow the screenshot layout)
          // Wait, in screenshot 1 (Hotel), description is AT THE BOTTOM.
          // In screenshot 2 (Room), description is BETWEEN title and price.
          // Let's implement it based on what is available:
          // Room has price, Hotel doesn't.
          // If it has price, we'll put description here, then price.
          
          if (price != null && description != null && description!.isNotEmpty) ...[
            const Gap(16),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: AppTypography.font(
                fontSize: 14,
                color: AppColors.immoTextSecondary,
                height: 1.4,
              ),
            ),
          ],

          // Price (For Room)
          if (price != null && price!.isNotEmpty) ...[
            const Gap(12),
            Text(
              price!,
              textAlign: TextAlign.center,
              style: AppTypography.font(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ],

          const Gap(20),

          // Rating and Comments row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rating column
              Column(
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: AppTypography.font(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(2),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 14,
                        color: index < rating.floor() ? Colors.amber : AppColors.immoBorderDefault,
                      );
                    }),
                  ),
                ],
              ),
              
              // Divider
              Container(
                height: 40,
                width: 1,
                color: AppColors.immoBorderStrong,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              
              // Comments column
              Column(
                children: [
                  Text(
                    commentCount.toString(),
                    style: AppTypography.font(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    "Commentaires",
                    style: AppTypography.font(
                      fontSize: 12,
                      color: AppColors.immoTextSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Description (For Hotel - at the bottom)
          if (price == null && description != null && description!.isNotEmpty) ...[
            const Gap(20),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: AppTypography.font(
                fontSize: 14,
                color: AppColors.immoTextSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
