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
      splashColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ── Icon container ──
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Iconsax.location,
                size: 20,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(width: 14),

            // ── Texts ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _mainText,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF222222),
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_subText.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      _subText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
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
            const SizedBox(width: 8),
            Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
