import 'package:flutter/material.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/screens/bien_location_sections.dart';
import 'package:immoplus/app/utils/filter_handler.dart';

class EstatesList extends StatelessWidget {
  const EstatesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BienLocationSectionsList(
      propertyType: PropertyType.estate,
      legacyPagingController: HomePageState.pagingControllerEstate,
    );
  }
}
