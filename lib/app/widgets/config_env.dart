import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/app_flavor.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  const EnvironmentsBadge({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'prod');

    return AppFlavor.isProd
        ? child
        : Banner(
            location: BannerLocation.topStart,
            message: flavor,
            color: AppColors.purple,
            child: child,
          );
  }
}
