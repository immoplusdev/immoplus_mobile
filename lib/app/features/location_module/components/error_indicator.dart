import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({Key? key, this.description, this.title})
      : super(key: key);

  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final hasContent = GetUtils.isNullOrBlank(title) == false ||
        GetUtils.isNullOrBlank(description) == false;

    if (!hasContent) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECACA), width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.warning_2,
              size: 20,
              color: AppColors.immoFeedbackError,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: AppTypography.font(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB91C1C),
                        height: 1.3,
                      ),
                    ),
                  if (description != null)
                    Text(
                      description!,
                      style: AppTypography.font(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.red600,
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
