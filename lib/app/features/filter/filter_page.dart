import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/filter/components/filter_range_price.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
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
  Widget build(BuildContext context) {
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
                tileColor: (currentAddress != null)
                    ? AppColors.scafold
                    : AppColors.scafold,
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
                    });
                  },
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: FilterRangePrice()),
          SliverToBoxAdapter(
            child: Center(
              child: TextButton(
                  onPressed: () {}, child: const Text('Annuler le filtre')),
            ),
          ),
          const SliverGap(50),
        ],
      ),
      bottomSheet: Container(
        height: 80,
        padding:
            const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 10),
        child: CustomButtom(
            text: 'Appliquer le filtre',
            onClick: () {
              context.pop();
            }),
      ),
    );
  }
}
