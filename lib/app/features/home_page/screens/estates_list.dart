import 'package:flutter/material.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/screens/estate_subcategory_sections.dart';

class EstatesList extends StatelessWidget {
  const EstatesList({super.key});

  @override
  Widget build(BuildContext context) {
    return EstateSubCategorySectionsList(
      legacyPagingController: HomePageState.pagingControllerEstate,
    );
  }
}
