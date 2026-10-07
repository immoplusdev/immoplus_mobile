import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// Sélecteur de tranche de prix / budget (kind = "price_range").
class PriceRangeFilterPicker extends StatelessWidget {
  final SearchFilterItem filter;
  final SearchFilterOption? selectedOption;
  final ValueChanged<SearchFilterOption?> onSelected;
  final double height;

  const PriceRangeFilterPicker({
    super.key,
    required this.filter,
    this.selectedOption,
    required this.onSelected,
    this.height = 35.0,
  });

  void _showPriceModal(BuildContext context) {
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (filter.allowAll)
                            _buildPriceTile(
                              label: 'Tous les budgets',
                              isSelected: currentSelected == null,
                              onTap: () {
                                setModalState(() => currentSelected = null);
                              },
                            ),
                          ...filter.options.map((option) {
                            final isSelected =
                                currentSelected?.value == option.value;
                            return _buildPriceTile(
                              label: option.label,
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
                  const Gap(20),
                  CustomButtom(
                    text: 'Confirmer',
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

  Widget _buildPriceTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.immoBorderDefault,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          label,
          style: AppTypography.font(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.black87,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: AppColors.primary, size: 20)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedOption != null;
    final text = hasSelection ? selectedOption!.label : filter.label;

    return InkWell(
      onTap: () => _showPriceModal(context),
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
              Iconsax.wallet_3,
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
          ],
        ),
      ),
    );
  }
}
