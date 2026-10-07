import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';

/// Champ de sélection de destination / localisation modulaire et réutilisable.
class DestinationSearchPicker extends StatelessWidget {
  final String? value;
  final String placeholder;
  final ValueChanged<Address?> onLocationSelected;
  final VoidCallback? onClear;
  final double height;

  const DestinationSearchPicker({
    super.key,
    this.value,
    this.placeholder = 'Destination',
    required this.onLocationSelected,
    this.onClear,
    this.height = 38.0,
  });

  Future<void> _openLocationSearch(BuildContext context) async {
    final result = await showModalBottomSheet<dynamic>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: LocationPage(),
      ),
    );

    if (result is Address) {
      onLocationSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;

    return InkWell(
      onTap: () => _openLocationSearch(context),
      borderRadius: BorderRadius.circular(32),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.immoBorderStrong),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Iconsax.location, color: AppColors.primary, size: 17),
            const Gap(8),
            Expanded(
              child: Text(
                hasValue ? value! : placeholder,
                style: AppTypography.font(
                  fontSize: 11,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                  color:
                      hasValue ? AppColors.black : AppColors.immoTextDisabled,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasValue)
              GestureDetector(
                onTap: onClear ?? () => onLocationSelected(null),
                child: Icon(
                  Icons.close,
                  color: AppColors.primary,
                  size: 15,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
