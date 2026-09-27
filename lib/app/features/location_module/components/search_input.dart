import 'package:immoplus/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../location_controller.dart';

class SearchInput extends GetView<LocationController> {
  const SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        color: AppColors.immoBgSurfaceMuted,
        child: TextField(
          controller: controller.searchController,
          autofocus: true,
          onChanged: (value) => controller.subject.add(value),
          cursorColor: const Color(0xFF3B82F6),
          style: AppTypography.font(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF222222),
          ),
          decoration: InputDecoration(
            hintText: 'Saisissez une adresse...',
            hintStyle: AppTypography.font(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.immoTextDisabled,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(
                Iconsax.search_normal_1,
                size: 20,
                color: AppColors.immoTextSecondary,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
