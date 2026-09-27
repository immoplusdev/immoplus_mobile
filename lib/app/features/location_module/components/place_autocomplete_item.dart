import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/location_module/location_controller.dart';

import '../data/model/autocomplete_response.dart';

class PlaceAutocompleteItem extends GetView<LocationController> {
  const PlaceAutocompleteItem({Key? key, required this.item}) : super(key: key);

  final CustomPrediction item;

  String get _mainText =>
      item.structuredFormatting?.mainText ?? item.description ?? '';

  String get _subText => item.structuredFormatting?.secondaryText ?? '';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.onAutocompleteItemClick(item),
      splashColor: AppColors.immoBgSurfaceMuted,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ── Icon container ──
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.immoBgSurfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Iconsax.location,
                size: 20,
                color: AppColors.immoTextSecondary,
              ),
            ),

            SizedBox(width: 14),

            // ── Texts ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _mainText,
                    style: AppTypography.font(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF222222),
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_subText.isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(
                      _subText,
                      style: AppTypography.font(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.immoTextSecondary,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // ── Trailing arrow ──
            SizedBox(width: 8),
            Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: AppColors.immoBorderStrong,
            ),
          ],
        ),
      ),
    );
  }
}
