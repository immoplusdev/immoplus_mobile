import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReverseSearchListHeader extends StatelessWidget {
  final String title;
  final String description;

  const ReverseSearchListHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.font(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(20),
        Expanded(
          child: Text(
            description,
            style: AppTypography.font(
              fontSize: 11,
              color: AppColors.immoTextSecondary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
