import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/design_system/design_system.dart';

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
              color: AppColors.navy900,
            )
          : AppTypography.h4.copyWith(
              fontWeight: FontWeight.w500,
            ),
    );
  }
}
