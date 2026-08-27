import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_page_header.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_shimmer_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Skeleton affiché pendant la vérification du statut d'activation du
/// module Hôtel (GET /pms/hotels/module-status), à la place d'un simple
/// CircularProgressIndicator.
class HotelSearchSkeletonView extends StatelessWidget {
  const HotelSearchSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const SafeArea(bottom: false, child: HotelPageHeader()),
          ),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [
                _shimmerBox(height: 150, radius: 20),
                const Gap(28),
                _shimmerSection(),
                const Gap(24),
                _shimmerSection(isSponsored: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _shimmerBox({
    required double height,
    double radius = 16,
    double? width,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1000),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  static Widget _shimmerSection({bool isSponsored = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _shimmerBox(height: 18, width: 140, radius: 4),
        ),
        SizedBox(
          height: isSponsored ? 335 : 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) =>
                HotelShimmerCard(isSponsored: isSponsored),
          ),
        ),
      ],
    );
  }
}
