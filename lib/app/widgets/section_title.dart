import 'package:flutter/material.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool useCalSans;
  const SectionTitle({super.key, required this.title, this.useCalSans = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: useCalSans
          ? AppTypography.h3.copyWith(
              color: AppColors.textCharcoal,
            )
          : AppTypography.h4.copyWith(
              fontWeight: FontWeight.w500,
            ),
    );
  }
}
