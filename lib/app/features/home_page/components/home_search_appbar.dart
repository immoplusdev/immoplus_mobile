import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/features/filter/logic/filter_cubit.dart';
import 'package:immoplus/app/features/home_page/components/home_choice_menu.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/screens/history_page_state.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/residence_filter_handler.dart';
import 'package:immoplus/app/widgets/custom_chip.dart';

class HomeSearchAppbar extends StatefulWidget {
  const HomeSearchAppbar(
      {super.key, required this.controller, required this.currentIndex});
  final TabController controller;
  final int currentIndex;
  @override
  State<HomeSearchAppbar> createState() => _HomeSearchAppbarState();
}

class _HomeSearchAppbarState extends State<HomeSearchAppbar> {
  final double iconSize = 28;
  final EdgeInsetsGeometry _iconMargin = const EdgeInsets.only(bottom: 3);
  onSelectPlace() {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      showDragHandle: true,
      backgroundColor: AppColors.whiteBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: LocationPage(),
      ),
    ).then(
      (value) {
        inspect(value);
        if (value is Address) {
          setState(() {
            FilterHandler.locationName = value.description!.length > 20
                ? '${value.description!.substring(0, 20)}…'
                : value.description;
            FilterHandler.lat = value.latitude;
            FilterHandler.long = value.longitude;
          });
          HomePageState.pagingControllerResidence.refresh();
          HomePageState.pagingControllerEstate.refresh();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterHandler>(
      builder: (context, state) {
        return SliverAppBar(
          automaticallyImplyLeading: false,
          pinned: true,
          snap: false,
          floating: true,
          titleSpacing: 0,
          //toolbarHeight: 60,

          backgroundColor: AppColors.whiteBackground,
          title: Container(
            color: AppColors.whiteBackground,
            padding: const EdgeInsets.all(10).copyWith(right: 0, left: 15),
            height: 60,
            child: CupertinoSearchTextField(
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: Colors.grey.shade700,
              ),
              onSubmitted: (keyword) {
                if (FilterHandler.search != null) {
                  if (FilterHandler.search!.isNotEmpty) {
                    log(keyword);
                    HomePageState.getPageListController(widget.currentIndex)
                        .refresh();
                  } else {
                    FilterHandler.search = null;
                    HomePageState.getPageListController(widget.currentIndex)
                        .refresh();
                  }
                }
              },
              onChanged: (text) {
                EasyDebounce.debounce(text, const Duration(milliseconds: 300),
                    () {
                  FilterHandler.search = text;
                  if (FilterHandler.search != null) {
                    if (FilterHandler.search!.isNotEmpty) {
                      log(text);
                      HomePageState.getPageListController(widget.currentIndex)
                          .refresh();
                    } else {
                      FilterHandler.search = null;
                      HomePageState.getPageListController(widget.currentIndex)
                          .refresh();
                    }
                  }
                });
              },
              placeholder: FilterHandler.search ??
                  'Maison, Résidence, Meuble, Terrain ...',
              placeholderStyle: GoogleFonts.inter(
                  fontSize: 14, color: CupertinoColors.systemGrey2),
              decoration: BoxDecoration(
                color: HexColor("#EDEFF9"),
                //color: Colors.red,
                borderRadius: BorderRadius.circular(20),
                // boxShadow: [
                //   BoxShadow(
                //       blurRadius: 8, spreadRadius: 1, color: Colors.grey.shade300),
                // ],
              ),
            ),
          ),

          actions: [
            (FilterHandler.locationName != null)
                ? UnconstrainedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 3),
                      child: CustomChip(
                        icon: Icons.location_on,
                        iconColor: Colors.blue.shade400,
                        label: FilterHandler.locationName!,
                        padding: EdgeInsets.symmetric(vertical: 0),
                        labelStyle: context.textTheme.bodySmall,
                        iconSize: 13,
                        onTap: onSelectPlace,
                        backgroundColor: Colors.grey.shade200,
                        trailing: InkWell(
                            onTap: () {
                              setState(() {
                                FilterHandler.locationName = null;
                                FilterHandler.lat = null;
                                FilterHandler.long = null;
                              });
                            },
                            child: Icon(
                              CupertinoIcons.xmark_circle_fill,
                              size: 15,
                              color: Colors.redAccent,
                            )),
                      ),
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(60),
                      splashFactory: InkRipple.splashFactory,
                      onTap: onSelectPlace,
                      child: Icon(
                        FontAwesomeIcons.map,
                        color: AppColors.primary,
                        size: 17,
                      ),
                    ),
                  ),
          ],

          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: HomeChoiceMenu()),
        );
      },
    );
  }
}
