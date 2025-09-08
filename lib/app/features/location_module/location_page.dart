import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import 'components/button_map.dart';
import 'components/current_location.dart';
import 'components/error_indicator.dart';
import 'components/location_indicator.dart';
import 'components/place_autocomplete_list.dart';
import 'components/search_input.dart';
import 'location_controller.dart';

/// Current position

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationController controller = Get.put(LocationController());

  @override
  void dispose() {
    super.dispose();
    Get.delete<LocationController>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_circle_left),
          ),
          title: const Text("Rechercher une adresse"),
        ),
        body: Column(
          children: [
            const Row(
              children: [
                Expanded(child: SearchInput()),
                ButtonMap(),
                Gap(16),
              ],
            ),
            controller.obx(
              (state) => const SizedBox(),
              onLoading: const SizedBox(),
              onError: (error) => ErrorIndicator(description: error.toString()),
            ),
            const CurrentLocationSection(),
            Expanded(
              child: controller.obx(
                (state) => const PlaceAutocompleteList(),
                onLoading: const LocationIndicator(),
                onError: (error) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
