import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// Sélecteur générique d'option (kind = "select", ex: Type de bien).
class FilterSelectPicker extends StatelessWidget {
  final SearchFilterItem filter;
  final SearchFilterOption? selectedOption;
  final ValueChanged<SearchFilterOption?> onSelected;
  final IconData icon;
  final double height;

  const FilterSelectPicker({
    super.key,
    required this.filter,
    this.selectedOption,
    required this.onSelected,
    this.icon = Iconsax.home,
    this.height = 35.0,
  });

  String _optionLabel(SearchFilterOption option) {
    final label = option.label.trim();
    return label.isNotEmpty ? label : option.value.toString();
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        SearchFilterOption? currentSelected = selectedOption;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        filter.label,
                        style: AppTypography.font(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentSelected != null)
                        TextButton(
                          onPressed: () {
                            setModalState(() => currentSelected = null);
                            onSelected(null);
                            Navigator.pop(modalContext);
                          },
                          child: Text(
                            'Effacer',
                            style: AppTypography.font(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: [
                          if (filter.allowAll)
                            _buildChoiceChip(
                              label: 'Tous',
                              isSelected: currentSelected == null,
                              onTap: () {
                                setModalState(() => currentSelected = null);
                              },
                            ),
                          ...filter.options.map((option) {
                            final isSelected =
                                currentSelected?.value == option.value;
                            return _buildChoiceChip(
                              label: _optionLabel(option),
                              isSelected: isSelected,
                              onTap: () {
                                setModalState(() => currentSelected = option);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  CustomButtom(
                    text: 'Valider',
                    onClick: () {
                      onSelected(currentSelected);
                      Navigator.pop(modalContext);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.immoBorderStrong,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.font(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedOption != null;
    final text = hasSelection ? _optionLabel(selectedOption!) : filter.label;

    return InkWell(
      onTap: () => _showOptionsModal(context),
      borderRadius: BorderRadius.circular(32),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color:
                hasSelection ? AppColors.primary : AppColors.immoBorderStrong,
            width: hasSelection ? 1.2 : 1.0,
          ),
          color: hasSelection
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13,
              color: AppColors.primary,
            ),
            const Gap(4),
            Flexible(
              child: Text(
                text,
                style: AppTypography.font(
                  fontSize: 10,
                  fontWeight: hasSelection ? FontWeight.bold : FontWeight.w500,
                  color: hasSelection ? AppColors.primary : AppColors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Gap(2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 12,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
