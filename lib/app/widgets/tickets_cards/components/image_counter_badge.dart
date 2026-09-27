import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';

class ImageCounterBadge extends StatelessWidget {
  final int current;
  final int total;

  const ImageCounterBadge({
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$current',
              style: AppTypography.font(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '/$total',
              style: AppTypography.font(
                color: AppColors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
