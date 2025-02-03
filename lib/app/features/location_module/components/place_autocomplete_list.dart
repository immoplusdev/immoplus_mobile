import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../location_controller.dart';
import 'place_autocomplete_item.dart';

class PlaceAutocompleteList extends GetView<LocationController> {
  const PlaceAutocompleteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => PlaceAutocompleteItem(
              item: controller.placeAutocompleteList[index]),
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.blueGrey.withOpacity(0.1),
          ),
          itemCount: controller.placeAutocompleteList.length,
        ));
  }
}
