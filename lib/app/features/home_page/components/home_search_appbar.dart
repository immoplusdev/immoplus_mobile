import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/features/filter/logic/filter_cubit.dart';
import 'package:immoplus/app/features/home_page/components/home_choice_menu.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';

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
          FilterHandler.notifyChange();
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
          toolbarHeight: 180,
          backgroundColor: AppColors.whiteBackground,
          title: Container(
            color: AppColors.whiteBackground,
            margin: EdgeInsets.symmetric(horizontal: 10),
            // height: 60,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/img/loc_ic.svg",
                      color: AppColors.primary,
                    ),
                    Gap(5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(39),
                      ),
                      child: Text(
                        "Blvd Charles bauza 21",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              fontSize: 13,
                            ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(NotificationsPage.name);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.F2F2F2,
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                        ),
                      ),
                    )
                  ],
                ),
                Gap(8),
                Text(
                  "Plannifie\nTon Sejour Idéal",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Gap(10),
                CupertinoSearchTextField(
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
                        FilterHandler.notifyChange();
                        HomePageState.getPageListController(widget.currentIndex)
                            .refresh();
                      }
                    }
                  },
                  onChanged: (text) {
                    EasyDebounce.debounce(
                        text, const Duration(milliseconds: 300), () {
                      FilterHandler.search = text;
                      FilterHandler.notifyChange();
                      if (FilterHandler.search != null) {
                        if (FilterHandler.search!.isNotEmpty) {
                          log(text);
                          HomePageState.getPageListController(
                                  widget.currentIndex)
                              .refresh();
                        } else {
                          FilterHandler.search = null;
                          FilterHandler.notifyChange();
                          HomePageState.getPageListController(
                                  widget.currentIndex)
                              .refresh();
                        }
                      }
                    });
                  },
                  placeholder: FilterHandler.search ??
                      'Maison, Résidence, Meuble, Terrain ...',
                  decoration: BoxDecoration(
                    color: HexColor("#EDEFF9"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),

          // actions: [
          //   (FilterHandler.locationName != null)
          //       ? UnconstrainedBox(
          //           child: Padding(
          //             padding: const EdgeInsets.only(left: 5, right: 3),
          //             child: CustomChip(
          //               icon: Icons.location_on,
          //               iconColor: Colors.blue.shade400,
          //               label: FilterHandler.locationName!,
          //               padding: EdgeInsets.symmetric(vertical: 0),
          //               labelStyle: context.textTheme.bodySmall,
          //               iconSize: 13,
          //               onTap: onSelectPlace,
          //               backgroundColor: Colors.grey.shade200,
          //               trailing: InkWell(
          //                   onTap: () {
          //                     setState(() {
          //                       FilterHandler.locationName = null;
          //                       FilterHandler.lat = null;
          //                       FilterHandler.long = null;
          //                     });
          //                     FilterHandler.notifyChange();
          //                   },
          //                   child: Icon(
          //                     CupertinoIcons.xmark_circle_fill,
          //                     size: 15,
          //                     color: Colors.redAccent,
          //                   )),
          //             ),
          //           ),
          //         )
          //       : Container(
          //           width: 40,
          //           height: 40,
          //           margin: const EdgeInsets.all(8),
          //           decoration: BoxDecoration(
          //             border: Border.all(color: Colors.grey.shade300),
          //             borderRadius: BorderRadius.circular(60),
          //           ),
          //           child: InkWell(
          //             borderRadius: BorderRadius.circular(60),
          //             splashFactory: InkRipple.splashFactory,
          //             onTap: onSelectPlace,
          //             child: Icon(
          //               FontAwesomeIcons.map,
          //               color: AppColors.primary,
          //               size: 17,
          //             ),
          //           ),
          //         ),
          // ],

          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: HomeChoiceMenu()),
        );
      },
    );
  }
}
