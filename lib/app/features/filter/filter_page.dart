import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/filter/components/filter_range_price.dart';
import 'package:immoplus/app/features/filter/logic/filter_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<DateTime?> markedDates = [];
  Address? currentAddress;

  @override
  void initState() {
    if (FilterHandler.locationName != null) {
      currentAddress = Address(
        latitude: FilterHandler.lat ?? 0,
        longitude: FilterHandler.long ?? 0,
        description: FilterHandler.locationName!,
      );
    }
    if (FilterHandler.startDate != null && FilterHandler.endDate != null) {
      try {
        markedDates.add(DateTime.parse(FilterHandler.startDate!));
        markedDates.add(DateTime.parse(FilterHandler.endDate!));
      } catch (e) {}
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.whiteBackground,
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(),
            SliverPadding(
              padding: const EdgeInsets.only(left: 15, bottom: 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Où souhaitez-vous loger ?',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.grey.shade500,
                      ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        FontAwesomeIcons.locationDot,
                        color: AppColors.primary,
                      )),
                  tileColor: AppColors.scafold,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text((currentAddress == null)
                      ? 'Sélectionner un lieu'
                      : currentAddress!.description.toString()),
                  trailing: Icon(
                    CupertinoIcons.chevron_down_circle_fill,
                    color: Colors.grey.shade300,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      useRootNavigator: true,
                      context: context,
                      isScrollControlled: true,
                      enableDrag: false,
                      showDragHandle: true,
                      backgroundColor: AppColors.whiteBackground,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      builder: (context) => const FractionallySizedBox(
                        heightFactor: 0.9,
                        child: LocationPage(),
                      ),
                    ).then(
                      (value) {
                        inspect(value);
                        if (value is Address) {
                          setState(() {
                            currentAddress = value;
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            const SliverGap(8),
            SliverPadding(
              padding: const EdgeInsets.only(left: 15, bottom: 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Quand souhaitez-vous réserver ?',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.grey.shade500,
                      ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.scafold,
                      borderRadius: BorderRadius.circular(20)),
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      controlsTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: AppColors.primary),
                      disableModePicker: true,
                      firstDayOfWeek: 1,
                      calendarType: CalendarDatePicker2Type.range,
                      centerAlignModePicker: true,
                      customModePickerIcon: const SizedBox(),
                      firstDate: DateTime.now(),
                      selectableDayPredicate: (day) => day.isAfter(
                          DateTime.now().subtract(const Duration(days: 1))),
                    ),
                    onDisplayedMonthChanged: null,
                    value: markedDates,
                    onValueChanged: (value) {
                      setState(() {
                        markedDates.clear();
                        markedDates.addAll(value);
                        inspect(markedDates);
                        FilterHandler.startDate = value.first.toIso8601String();
                        FilterHandler.endDate = value.length > 1
                            ? value.last.toIso8601String()
                            : null;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: FilterRangePrice()),
            const SliverGap(50),
          ],
        ),
        bottomSheet: Container(
          height: 120,
          padding:
              const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButtom(
                  text: 'Appliquer le filtre',
                  onClick: () {
                    if (currentAddress != null) {
                      FilterHandler.locationName = currentAddress!.description;
                      FilterHandler.lat = currentAddress!.latitude;
                      FilterHandler.long = currentAddress!.longitude;
                    }
                    FilterHandler.notifyChange();

                    HomePageState.getPageListController(state.indexPage)
                        .refresh();
                    context.read<FilterCubit>().refresh(FilterHandler());
                    context.pop();
                  }),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                  onPressed: () {
                    setState(() {
                      FilterHandler.cleanParameters();
                    });
                    HomePageState.getPageListController(state.indexPage)
                        .refresh();
                    context.read<FilterCubit>().refresh(FilterHandler());
                    context.pop();
                  },
                  child: const Text('Annuler les filtres')),
            ],
          ),
        ),
      );
    });
  }
}
