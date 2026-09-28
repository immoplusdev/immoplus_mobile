import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';

class AddsTag extends StatelessWidget {
  const AddsTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black, width: .2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Text(
        "Ads",
        style: AppTypography.font(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
