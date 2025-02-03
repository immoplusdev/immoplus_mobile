import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:immoplus/app/features/location_module/location_controller.dart';

import '../data/model/autocomplete_response.dart';

class PlaceAutocompleteItem extends GetView<LocationController> {
  const PlaceAutocompleteItem({Key? key, required this.item}) : super(key: key);

  final CustomPrediction item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => controller.onAutocompleteItemClick(item),
        contentPadding: const EdgeInsets.only(left: 16, right: 16),
        leading: const Icon(
          FontAwesomeIcons.locationDot,
          color: Colors.blueGrey,
        ),
        title: Text(
          // Prediction.reference is used as [Address.alias]
          (item.structuredFormatting != null)
              ? item.structuredFormatting!.mainText ?? item.description ?? ""
              : item.description ?? "",
          style: context.textTheme.titleLarge?.copyWith(),
        ),
        subtitle: (item.structuredFormatting != null)
            ? (item.structuredFormatting!.mainText != null)
                ? Text(
                    item.structuredFormatting!.secondaryText ?? "",
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.blueGrey,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  )
                : null
            : null
        // (controller.previousAddresses.any((element) =>
        //             element.placeId != null && element.placeId == item.placeId) &&
        //         (item.reference?.isNotEmpty ?? false) &&
        //         (item.description?.isNotEmpty ?? false))
        //     ? Text(
        //         item.description ?? "",
        //         style: context.textTheme.titleMedium?.copyWith(
        //           color: Colors.blueGrey,
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //         maxLines: 1,
        //       )
        //     : null,
        );
  }
}
