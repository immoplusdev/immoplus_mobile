import 'package:flutter/material.dart';
import 'package:immoplus/app/data/enums/filter_kind.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/widgets/filters/filter_select_picker.dart';
import 'package:immoplus/app/widgets/filters/min_count_filter_picker.dart';
import 'package:immoplus/app/widgets/filters/price_range_filter_picker.dart';

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
    this.height = 35.0,
  });

  FilterKind get _kind => FilterKind.fromValue(filter.kind);

  @override
  Widget build(BuildContext context) {
    switch (_kind) {
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
