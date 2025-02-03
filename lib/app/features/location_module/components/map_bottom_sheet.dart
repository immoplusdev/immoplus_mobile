import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/location_module/components/error_indicator.dart';
import 'package:immoplus/app/features/location_module/location_controller.dart';

class MapBottomSheet extends GetView<LocationController> {
  const MapBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          centerTitle: false,
          leading: const SizedBox(),
          leadingWidth: 0,
          title: Text(
            "VOTRE ADRESSE".toUpperCase(),
            style: context.textTheme.headlineSmall?.copyWith(
              color: Colors.black,
              fontFamily: "AppFontBold",
            ),
            maxLines: 1,
          ),
        ),
        controller.obx(
          (state) => const SizedBox(),
          onLoading: const SizedBox(),
          onError: (error) => ErrorIndicator(description: error),
        ),
        Material(
          child: controller.obx(
            (state) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              onTap: () {
                context.pop();
                context.pop(controller.cameraAddress.value);
              },
              tileColor: context.theme.colorScheme.primary,
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
      ],
    );
  }
}
