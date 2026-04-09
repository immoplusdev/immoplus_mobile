import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/location_module/location_map_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class ButtonMap extends StatelessWidget {
  const ButtonMap({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LocationMapPage()),
        );
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Iconsax.map_1,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
