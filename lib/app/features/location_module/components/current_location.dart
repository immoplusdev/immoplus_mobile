import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:immoplus/app/features/location_module/location_controller.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class CurrentLocationSection extends GetView<LocationController> {
  const CurrentLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: controller.obx(
        (state) => TextButton.icon(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: AppColors.primaryLite,
            ),
            onPressed: () => controller.getCurrentPosition(
                latitude: currentPosition.value.latitude ?? 0,
                longitude: currentPosition.value.longitude ?? 0),
            icon:
                const Icon(FontAwesomeIcons.locationArrow, color: Colors.black),
            label: Text(
              'Ma position actuelle',
              style: context.textTheme.titleLarge?.copyWith(),
            )),
        onLoading: TextButton.icon(
            onPressed: null,
            icon: const Icon(FontAwesomeIcons.locationArrow),
            label: const Text('Ma position actuelle')),
        onError: (error) => TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: null,
            //  () => controller.getCurrentPosition(
            //     latitude: currentPosition.value.latitude ?? 0,
            //     longitude: currentPosition.value.longitude ?? 0),
            icon:
                const Icon(FontAwesomeIcons.locationArrow, color: Colors.black),
            label: Text(
              'Ma position actuelle',
              style: context.textTheme.titleLarge?.copyWith(),
            )),
      ),
    );
  }
}
