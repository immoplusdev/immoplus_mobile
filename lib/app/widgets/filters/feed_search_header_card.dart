import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/filters/destination_search_picker.dart';
import 'package:immoplus/app/widgets/filters/dynamic_filter_picker.dart';

/// Carte de recherche flottante en en-tête pour les filtres du flux vertical.
class FeedSearchHeaderCard extends StatelessWidget {
  final HomeFeedScope scope;
  final String? destinationName;
  final ValueChanged<Address?> onLocationSelected;
  final List<SearchFilterItem> filters;
  final Map<String, SearchFilterOption?> selectedFilters;
  final Function(String filterKey, SearchFilterOption? option) onFilterChanged;
  final VoidCallback? onSearch;

  const FeedSearchHeaderCard({
    super.key,
    required this.scope,
    this.destinationName,
    required this.onLocationSelected,
    this.filters = const [],
    required this.selectedFilters,
    required this.onFilterChanged,
    this.onSearch,
  });

  bool get _isStay => scope.isStay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Destination
            DestinationSearchPicker(
              value: destinationName,
              placeholder: _isStay
                  ? 'Où voulez-vous séjourner ?'
                  : 'Commune, quartier ou ville',
              onLocationSelected: onLocationSelected,
              onClear: () => onLocationSelected(null),
            ),

            // 2. Filtres applicables à la même route que le flux.
            if (filters.isNotEmpty) ...[
              const Gap(10),
              _buildFiltersLayout(filters),
            ],

            const Gap(12),

            // 3. Bouton Chercher
            CustomButtom(
              buttonHeight: 44,
              child: Text(
                'Chercher',
                style: AppTypography.font(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              onClick: onSearch ?? () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersLayout(List<SearchFilterItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();

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
              height: 32,
            ),
          ),
          const Gap(8),
          Expanded(
            child: DynamicFilterPicker(
              filter: items[1],
              selectedOption: selectedFilters[items[1].key],
              onSelected: (opt) => onFilterChanged(items[1].key, opt),
              height: 32,
            ),
          ),
        ],
      );
    }

    // Quatre filtres principaux : une ligne compacte, dans l'ordre de l'API.
    if (items.length == 4) {
      return Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const Gap(4),
            Expanded(
              child: DynamicFilterPicker(
                filter: items[index],
                selectedOption: selectedFilters[items[index].key],
                onSelected: (opt) => onFilterChanged(items[index].key, opt),
              ),
            ),
          ],
        ],
      );
    }

    // Trois filtres gardent la même largeur et la même hauteur sur une ligne.
    if (items.length == 3) {
      return Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const Gap(6),
            Expanded(
              child: DynamicFilterPicker(
                filter: items[index],
                selectedOption: selectedFilters[items[index].key],
                onSelected: (opt) => onFilterChanged(items[index].key, opt),
                height: 32,
              ),
            ),
          ],
        ],
      );
    }

    // Si plus de 3 filtres : découpage par rangées de 2 avec alignement à gauche pour un élément restant seul
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      final chunk =
          items.sublist(i, (i + 2 > items.length) ? items.length : i + 2);
      if (rows.isNotEmpty) {
        rows.add(const Gap(10));
      }
      if (chunk.length == 1) {
        final f = chunk[0];
        rows.add(
          Row(
            children: [
              Expanded(
                child: DynamicFilterPicker(
                  filter: f,
                  selectedOption: selectedFilters[f.key],
                  onSelected: (opt) => onFilterChanged(f.key, opt),
                ),
              ),
              const Gap(8),
              const Expanded(
                child: SizedBox.shrink(),
              ),
            ],
          ),
        );
      } else {
        rows.add(
          Row(
            children: [
              Expanded(
                child: DynamicFilterPicker(
                  filter: chunk[0],
                  selectedOption: selectedFilters[chunk[0].key],
                  onSelected: (opt) => onFilterChanged(chunk[0].key, opt),
                ),
              ),
              const Gap(8),
              Expanded(
                child: DynamicFilterPicker(
                  filter: chunk[1],
                  selectedOption: selectedFilters[chunk[1].key],
                  onSelected: (opt) => onFilterChanged(chunk[1].key, opt),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}
