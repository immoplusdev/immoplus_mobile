import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';

class HotelShimmerCard extends StatelessWidget {
  final bool isSponsored;

  const HotelShimmerCard({super.key, this.isSponsored = false});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = isSponsored ? 373 : 253;
    final double imageHeight = isSponsored ? 200 : 130;

    return Shimmer.fromColors(
      baseColor: AppColors.immoBorderStrong,
      highlightColor: AppColors.immoBgSurfaceMuted,
      period: const Duration(milliseconds: 1000),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: cardWidth * 0.7,
                      height: 16,
                      color: AppColors.white,
                    ),
                    const Gap(8),
                    Container(
                      width: cardWidth * 0.4,
                      height: 12,
                      color: AppColors.white,
                    ),
                    const Gap(8),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
