import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/filters/daterange_filter_picker.dart';
import 'package:immoplus/app/widgets/filters/destination_search_picker.dart';
import 'package:immoplus/app/widgets/filters/dynamic_filter_picker.dart';

/// Carte de recherche flottante en en-tête inspirée de la page Hôtel,
/// construite dynamiquement à partir des filtres de `GET /me/search/filters`.
class FeedSearchHeaderCard extends StatelessWidget {
  final HomeFeedScope scope;
  final String? destinationName;
  final ValueChanged<Address?> onLocationSelected;
  final List<SearchFilterItem> filters;
  final Map<String, SearchFilterOption?> selectedFilters;
  final Function(String filterKey, SearchFilterOption? option) onFilterChanged;
  final DateTimeRange? selectedDateRange;
  final ValueChanged<DateTimeRange?>? onDateRangeSelected;
  final VoidCallback? onSearch;

  const FeedSearchHeaderCard({
    super.key,
    required this.scope,
    this.destinationName,
    required this.onLocationSelected,
    this.filters = const [],
    required this.selectedFilters,
    required this.onFilterChanged,
    this.selectedDateRange,
    this.onDateRangeSelected,
    this.onSearch,
  });

  bool get _isStay => scope.isStay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Fond coloré en haut avec coins arrondis
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
        ),

        // Carte flottante de recherche
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFCFEFF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.immoBorderDefault),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Destination
                DestinationSearchPicker(
                  value: destinationName,
                  placeholder: _isStay
                      ? 'Où voulez-vous séjourner ?'
                      : 'Ville, quartier ou commune...',
                  onLocationSelected: onLocationSelected,
                  onClear: () => onLocationSelected(null),
                ),

                const Gap(12),

                // 2. Filtres dynamiques / Dates pour séjour
                if (_isStay && onDateRangeSelected != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: DaterangeFilterPicker(
                          selectedRange: selectedDateRange,
                          onDateRangeSelected: onDateRangeSelected!,
                        ),
                      ),
                      if (filters.isNotEmpty) ...[
                        const Gap(8),
                        Expanded(
                          child: DynamicFilterPicker(
                            filter: filters.first,
                            selectedOption: selectedFilters[filters.first.key],
                            onSelected: (opt) =>
                                onFilterChanged(filters.first.key, opt),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (filters.length > 1) ...[
                    const Gap(10),
                    _buildFilterRow(filters.sublist(1)),
                  ],
                ] else if (filters.isNotEmpty) ...[
                  _buildFilterRow(filters),
                ],

                const Gap(14),

                // 3. Bouton Chercher
                CustomButtom(
                  text: 'Chercher',
                  onClick: onSearch ?? () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow(List<SearchFilterItem> items) {
    if (items.length == 1) {
      final f = items[0];
      return DynamicFilterPicker(
        filter: f,
        selectedOption: selectedFilters[f.key],
        onSelected: (opt) => onFilterChanged(f.key, opt),
      );
    }

    if (items.length == 2) {
      return Row(
        children: [
          Expanded(
            child: DynamicFilterPicker(
              filter: items[0],
              selectedOption: selectedFilters[items[0].key],
              onSelected: (opt) => onFilterChanged(items[0].key, opt),
            ),
          ),
          const Gap(8),
          Expanded(
            child: DynamicFilterPicker(
              filter: items[1],
              selectedOption: selectedFilters[items[1].key],
              onSelected: (opt) => onFilterChanged(items[1].key, opt),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: DynamicFilterPicker(
            filter: items[0],
            selectedOption: selectedFilters[items[0].key],
            onSelected: (opt) => onFilterChanged(items[0].key, opt),
          ),
        ),
        const Gap(6),
        Expanded(
          flex: 4,
          child: DynamicFilterPicker(
            filter: items[1],
            selectedOption: selectedFilters[items[1].key],
            onSelected: (opt) => onFilterChanged(items[1].key, opt),
          ),
        ),
        const Gap(6),
        Expanded(
          flex: 3,
          child: DynamicFilterPicker(
            filter: items[2],
            selectedOption: selectedFilters[items[2].key],
            onSelected: (opt) => onFilterChanged(items[2].key, opt),
          ),
        ),
      ],
    );
  }
}
