import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';

class ReverseSearchChip extends StatelessWidget {
  final String text;
  final String? badge;
  final VoidCallback onTap;

  const ReverseSearchChip({
    super.key,
    required this.text,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFC0CAFF),
          borderRadius: BorderRadius.circular(20),
          border: Border(
            bottom: BorderSide(color: AppColors.immoBrandPrimary, width: 2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: AppTypography.font(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            if (badge != null && badge!.isNotEmpty) ...[
              SizedBox(width: 2),
              Transform.translate(
                offset: const Offset(0, -6),
                child: Text(
                  badge!,
                  style: AppTypography.font(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.immoBrandPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
