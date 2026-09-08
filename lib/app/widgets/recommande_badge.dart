import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class RecommandeBadge extends StatelessWidget {
  const RecommandeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.badgeRecommendBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: AppColors.goldStar, size: 12),
          Gap(4),
          Text(
            'Recommandé',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class FreeReverseBadge extends StatelessWidget {
  const FreeReverseBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.badgeUrgentOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Libre',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
