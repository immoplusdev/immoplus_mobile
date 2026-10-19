import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:intl/intl.dart';

/// Sélecteur de plage de dates modulaire et réutilisable.
class DaterangeFilterPicker extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final String placeholder;
  final ValueChanged<DateTimeRange?> onDateRangeSelected;
  final double height;
  final DateFormat? dateFormat;

  const DaterangeFilterPicker({
    super.key,
    this.selectedRange,
    this.placeholder = 'Sélectionner les dates',
    required this.onDateRangeSelected,
    this.height = 35.0,
    this.dateFormat,
  });

  Future<void> _selectDates(BuildContext context) async {
    final values = selectedRange == null
        ? <DateTime?>[]
        : [selectedRange!.start, selectedRange!.end];

    final picked = await showDialog<List<DateTime?>>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: 350,
          height: 400,
          child: CalendarDatePicker2WithActionButtons(
            config: CalendarDatePicker2WithActionButtonsConfig(
              calendarType: CalendarDatePicker2Type.range,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              selectedDayHighlightColor: AppColors.primary,
              selectedRangeHighlightColor:
                  AppColors.primary.withValues(alpha: 0.1),
              closeDialogOnCancelTapped: false,
              closeDialogOnOkTapped: false,
              okButton: Text(
                'Confirmer',
                style: AppTypography.font(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              cancelButton: Text(
                'Annuler',
                style: AppTypography.font(color: AppColors.immoTextSecondary),
              ),
            ),
            value: values,
            onValueChanged: (dates) {
              values.clear();
              values.addAll(dates);
            },
            onOkTapped: () {
              Navigator.pop(context, values);
            },
            onCancelTapped: () {
              Navigator.pop(context, null);
            },
          ),
        ),
      ),
    );

    if (picked != null &&
        picked.length >= 2 &&
        picked[0] != null &&
        picked[1] != null) {
      onDateRangeSelected(
        DateTimeRange(start: picked[0]!, end: picked[1]!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = dateFormat ?? DateFormat('dd MMM', 'fr_FR');
    final hasRange = selectedRange != null;
    final text = hasRange
        ? '${formatter.format(selectedRange!.start)} - ${formatter.format(selectedRange!.end)}'
        : placeholder;

    return InkWell(
      onTap: () => _selectDates(context),
      borderRadius: BorderRadius.circular(32),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.immoBorderStrong),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Iconsax.calendar_1, size: 15, color: AppColors.primary),
            const Gap(6),
            Expanded(
              child: Text(
                text,
                style: AppTypography.font(
                  fontSize: 10,
                  fontWeight: hasRange ? FontWeight.bold : FontWeight.normal,
                  color:
                      hasRange ? AppColors.black : AppColors.immoTextSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasRange)
              GestureDetector(
                onTap: () => onDateRangeSelected(null),
                child: Icon(
                  Icons.close,
                  color: AppColors.primary,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
