import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/location_module/location_controller.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class CurrentLocationSection extends GetView<LocationController> {
  const CurrentLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) => _LocationTile(
        onTap: () => controller.getCurrentPosition(),
        loading: false,
      ),
      onLoading: const _LocationTile(loading: true),
      onError: (_) => _LocationTile(
        onTap: () => controller.getCurrentPosition(),
        loading: false,
        hasError: true,
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    this.onTap,
    this.loading = false,
    this.hasError = false,
  });
  final VoidCallback? onTap;
  final bool loading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      splashColor: AppColors.primary.withOpacity(0.06),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: hasError
                    ? Colors.red.shade50
                    : AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: loading
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Icon(
                      Iconsax.gps,
                      size: 22,
                      color:
                          hasError ? Colors.red.shade400 : AppColors.primary,
                    ),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ma position actuelle',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF222222),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasError
                        ? 'Localisation non disponible'
                        : 'Utiliser ma position GPS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            if (!loading)
              Icon(
                Iconsax.arrow_right_3,
                size: 16,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
