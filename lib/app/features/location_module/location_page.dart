import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'components/button_map.dart';
import 'components/current_location.dart';
import 'components/error_indicator.dart';
import 'components/location_indicator.dart';
import 'components/place_autocomplete_list.dart';
import 'components/search_input.dart';
import 'location_controller.dart';

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
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle ──
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Header ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Iconsax.arrow_left,
                          size: 18,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Rechercher une adresse',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),

              // ── Search + Map button ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: const [
                    Expanded(child: SearchInput()),
                    SizedBox(width: 10),
                    ButtonMap(),
                  ],
                ),
              ),

              // ── Error banner ──
              controller.obx(
                (state) => const SizedBox(),
                onLoading: const SizedBox(),
                onError: (error) =>
                    ErrorIndicator(description: error.toString()),
              ),

              // ── Current location ──
              const CurrentLocationSection(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                    height: 1, thickness: 0.5, color: Colors.grey.shade100),
              ),

              // ── Section label ──
              controller.obx(
                (state) {
                  if (state?.isEmpty ?? true) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                    child: Text(
                      'RÉSULTATS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                },
                onLoading: const SizedBox(),
                onError: (_) => const SizedBox(),
              ),

              // ── Autocomplete list ──
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
      ),
    );
  }
}
