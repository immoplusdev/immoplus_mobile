import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/location_module/components/error_indicator.dart';
import 'package:immoplus/app/features/location_module/location_controller.dart';
import 'package:immoplus/app/widgets/map/location_permission_banner.dart';

class MapBottomSheet extends GetView<LocationController> {
  const MapBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "VOTRE ADRESSE".toUpperCase(),
              style: context.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontFamily: "AppFontBold",
              ),
              maxLines: 1,
            ),
          ),
          LocationPermissionBanner(showAction: false),
          controller.obx(
            (state) => const SizedBox(),
            onLoading: const SizedBox(),
            onError: (error) => ErrorIndicator(description: error),
          ),
          Material(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: context.theme.colorScheme.primary,
              child: controller.obx(
                (state) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {
                    context.pop();
                    context.pop(controller.cameraAddress.value);
                  },
                  title: Text(
                    controller.cameraAddress.value.description ?? "",
                    //"",
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  subtitle: Text(
                    "Sélectionnez cette adresse",
                    style: context.textTheme.titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Colors.white,
                  ),
                ),
                onLoading: ListTile(
                  tileColor: context.theme.colorScheme.primary.withOpacity(0.5),
                  title: const CupertinoActivityIndicator(color: Colors.white),
                ),
                onError: (error) => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
