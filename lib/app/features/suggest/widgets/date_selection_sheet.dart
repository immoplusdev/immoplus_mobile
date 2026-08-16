import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class DateSelectionSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const DateSelectionSheet({super.key, this.initialStartDate, this.initialEndDate});

  static Future<DateTimeRange?> show(BuildContext context, DateTime? start, DateTime? end) {
    return showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DateSelectionSheet(initialStartDate: start, initialEndDate: end),
    );
  }

  @override
  State<DateSelectionSheet> createState() => _DateSelectionSheetState();
}

class _DateSelectionSheetState extends State<DateSelectionSheet> {
  List<DateTime?> _dialogCalendarPickerValue = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialStartDate != null && widget.initialEndDate != null) {
      _dialogCalendarPickerValue = [
        widget.initialStartDate,
        widget.initialEndDate,
      ];
    } else if (widget.initialStartDate != null) {
      _dialogCalendarPickerValue = [widget.initialStartDate];
    }
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = "Sélectionner des dates";

    if (_dialogCalendarPickerValue.length > 1 && 
        _dialogCalendarPickerValue[0] != null && 
        _dialogCalendarPickerValue[1] != null) {
      final diff = _dialogCalendarPickerValue[1]!.difference(_dialogCalendarPickerValue[0]!).inDays;
      if (diff > 0) {
        buttonText = "Garder $diff nuits";
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quand ?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
              selectedDayHighlightColor: AppColors.primary,
              weekdayLabels: ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
              weekdayLabelTextStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              firstDayOfWeek: 1, // Start on Monday
              controlsTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              dayTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              selectedDayTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            value: _dialogCalendarPickerValue,
            onValueChanged: (dates) => setState(() => _dialogCalendarPickerValue = dates),
          ),
          const SizedBox(height: 16),
          CustomButtom(
            text: buttonText,
            onClick: () {
              if (_dialogCalendarPickerValue.length == 2 && 
                  _dialogCalendarPickerValue[0] != null && 
                  _dialogCalendarPickerValue[1] != null) {
                Navigator.pop(
                  context,
                  DateTimeRange(
                    start: _dialogCalendarPickerValue[0]!,
                    end: _dialogCalendarPickerValue[1]!,
                  ),
                );
              } else {
                // If only one date or no date selected, just close without range
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 16), // SafeArea bottom spacing
        ],
      ),
    );
  }
}
