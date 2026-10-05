import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// Sélecteur de nombre minimum (kind = "min_count", ex: Chambres 1+, 2+...).
class MinCountFilterPicker extends StatelessWidget {
  final SearchFilterItem filter;
  final SearchFilterOption? selectedOption;
  final ValueChanged<SearchFilterOption?> onSelected;
  final IconData icon;
  final double height;

  const MinCountFilterPicker({
    super.key,
    required this.filter,
    this.selectedOption,
    required this.onSelected,
    this.icon = Icons.bed_outlined,
    this.height = 35.0,
  });

  void _showModal(BuildContext context) {
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
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (filter.allowAll)
                        _buildCountCircle(
                          label: 'Tous',
                          isSelected: currentSelected == null,
                          onTap: () {
                            setModalState(() => currentSelected = null);
                          },
                        ),
                      ...filter.options.map((option) {
                        final isSelected =
                            currentSelected?.value == option.value;
                        return _buildCountCircle(
                          label: option.label,
                          isSelected: isSelected,
                          onTap: () {
                            setModalState(() => currentSelected = option);
                          },
                        );
                      }),
                    ],
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

  Widget _buildCountCircle({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.immoBorderStrong,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.font(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.white : AppColors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedOption != null;
    final text = hasSelection ? selectedOption!.label : filter.label;

    return InkWell(
      onTap: () => _showModal(context),
      borderRadius: BorderRadius.circular(32),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: hasSelection ? AppColors.primary : AppColors.immoBorderStrong,
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
              size: 15,
              color: hasSelection ? AppColors.primary : AppColors.immoTextSecondary,
            ),
            const Gap(4),
            Flexible(
              child: Text(
                text,
                style: AppTypography.font(
                  fontSize: 12.5,
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
