import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/utils/formular_utils.dart';

class DetailLogmentAvailableDay extends StatelessWidget {
  const DetailLogmentAvailableDay({super.key, required this.reservation});
  final ResidenceModel reservation;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder(
          future: FormUtils.getDateBooked(id: reservation.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  disableModePicker: true,
                  firstDayOfWeek: 1,
                  calendarType: CalendarDatePicker2Type.multi,
                  selectedDayTextStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),

                  selectedDayHighlightColor: CupertinoColors.systemFill,
                  centerAlignModePicker: true,
                  customModePickerIcon: const SizedBox(),
                  firstDate: DateTime.now(),
                  selectableDayPredicate: (day) {
                    print(day);
                    return false;
                  },

                  dayBuilder: (
                          {required date,
                          decoration,
                          isDisabled,
                          isSelected,
                          isToday,
                          textStyle}) =>
                      IgnorePointer(
                    ignoring: true,
                    child: CircleAvatar(
                      backgroundColor:
                          isSelected! ? Colors.red : Colors.transparent,
                      child: Text(
                        date.day.toString(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: (isSelected)
                                  ? CupertinoColors.white
                                  : Colors.black,
                              decoration: isSelected
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                      ),
                    ),
                  ),
                  //   dayBuilder: _yourDayBuilder,
                  //   yearBuilder: _yourYearBuilder,
                ),
                onDisplayedMonthChanged: null,
                value: FormUtils.markedDates,
                onValueChanged: (value) {
                  log(value.toString(), name: 'VALUE');
                },
              );
            }
            return const Center(child: CupertinoActivityIndicator());
          }),
    );
  }
}
