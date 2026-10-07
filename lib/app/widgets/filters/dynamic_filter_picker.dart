import 'package:flutter/material.dart';
import 'package:immoplus/app/data/enums/filter_kind.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/widgets/filters/daterange_filter_picker.dart';
import 'package:immoplus/app/widgets/filters/filter_select_picker.dart';
import 'package:immoplus/app/widgets/filters/min_count_filter_picker.dart';
import 'package:immoplus/app/widgets/filters/price_range_filter_picker.dart';
import 'package:intl/intl.dart';

/// Composant modulaire qui dispatche automatiquement le sélecteur adapté
/// selon le [SearchFilterItem.kind] renvoyé par l'API `GET /me/search/filters`.
class DynamicFilterPicker extends StatelessWidget {
  final SearchFilterItem filter;
  final SearchFilterOption? selectedOption;
  final ValueChanged<SearchFilterOption?> onSelected;
  final double height;

  const DynamicFilterPicker({
    super.key,
    required this.filter,
    this.selectedOption,
    required this.onSelected,
    this.height = 32.0,
  });

  FilterKind get _kind => FilterKind.fromValue(filter.kind);

  DateTimeRange? _extractDateRange(SearchFilterOption? option) {
    if (option == null) return null;
    if (option.value is DateTimeRange) {
      return option.value as DateTimeRange;
    }
    if (option.value is List && (option.value as List).length >= 2) {
      final list = option.value as List;
      if (list[0] is DateTime && list[1] is DateTime) {
        return DateTimeRange(
          start: list[0] as DateTime,
          end: list[1] as DateTime,
        );
      }
    }
    if (option.params.isNotEmpty) {
      final values = option.params.values.toList();
      if (values.length >= 2) {
        final start = DateTime.tryParse(values[0]?.toString() ?? '');
        final end = DateTime.tryParse(values[1]?.toString() ?? '');
        if (start != null && end != null) {
          return DateTimeRange(start: start, end: end);
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    switch (_kind) {
      case FilterKind.dateRange:
        return DaterangeFilterPicker(
          selectedRange: _extractDateRange(selectedOption),
          placeholder:
              filter.label.isNotEmpty ? filter.label : 'Sélectionner les dates',
          height: height,
          onDateRangeSelected: (range) {
            if (range == null) {
              onSelected(null);
              return;
            }
            final startKey =
                filter.params.isNotEmpty ? filter.params[0] : 'start_date';
            final endKey =
                filter.params.length > 1 ? filter.params[1] : 'end_date';
            final dateIsoFormat = DateFormat('yyyy-MM-dd');
            final dateDisplayFormat = DateFormat('dd MMM', 'fr_FR');

            onSelected(
              SearchFilterOption(
                value: range,
                label:
                    '${dateDisplayFormat.format(range.start)} - ${dateDisplayFormat.format(range.end)}',
                params: {
                  startKey: dateIsoFormat.format(range.start),
                  endKey: dateIsoFormat.format(range.end),
                },
              ),
            );
          },
        );
      case FilterKind.priceRange:
        return PriceRangeFilterPicker(
          filter: filter,
          selectedOption: selectedOption,
          onSelected: onSelected,
          height: height,
        );
      case FilterKind.minCount:
        return MinCountFilterPicker(
          filter: filter,
          selectedOption: selectedOption,
          onSelected: onSelected,
          height: height,
        );
      case FilterKind.select:
        return FilterSelectPicker(
          filter: filter,
          selectedOption: selectedOption,
          onSelected: onSelected,
          height: height,
        );
    }
  }
}
