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
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1000),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
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
                      color: Colors.white,
                    ),
                    const Gap(8),
                    Container(
                      width: cardWidth * 0.4,
                      height: 12,
                      color: Colors.white,
                    ),
                    const Gap(8),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
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
