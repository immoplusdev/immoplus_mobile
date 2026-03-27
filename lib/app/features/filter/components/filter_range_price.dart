import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:intl/intl.dart';

class FilterRangePrice extends StatefulWidget {
  const FilterRangePrice({super.key});

  @override
  State<FilterRangePrice> createState() => _FilterRangePriceState();
}

class _FilterRangePriceState extends State<FilterRangePrice> {
  final double _priceStep = 10;
  final double _minPriceLimit = minPriceLimit.toDouble();
  final double _maxPriceLimit = maxPriceLimit.toDouble();

  late TextEditingController _minController;
  late TextEditingController _maxController;

  final NumberFormat _format = NumberFormat.decimalPattern('fr_FR');

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: _format.format(FilterHandler.minPrice),
    );
    _maxController = TextEditingController(
      text: _format.format(FilterHandler.maxPrice),
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _updateControllersFromSlider() {
    _minController.text = _format.format(FilterHandler.minPrice);
    _maxController.text = _format.format(FilterHandler.maxPrice);
  }

  int _parseFormattedNumber(String text) {
    // Enlever les espaces du format français (1 000 000 -> 1000000)
    final cleanText = text.replaceAll(RegExp(r'\s'), '');
    return int.tryParse(cleanText) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fourchette de prix',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF344054),
                ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF2F4F7)),
            ),
            child: Column(
              children: [
                // Min / Max input fields
                Row(
                  children: [
                    Expanded(
                      child: _buildPriceInput(
                        context,
                        label: 'Minimum',
                        controller: _minController,
                        icon: Iconsax.arrow_down_1,
                        onChanged: (value) {
                          final parsed = _parseFormattedNumber(value);
                          final clamped = parsed.clamp(
                            _minPriceLimit.toInt(),
                            FilterHandler.maxPrice,
                          );
                          FilterHandler.minPrice =
                              ((clamped / _priceStep).round() * _priceStep)
                                  .toInt();
                          setState(() {});
                        },
                        onEditingComplete: () {
                          _minController.text =
                              _format.format(FilterHandler.minPrice);
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    const Gap(12),
                    Container(
                      width: 24,
                      height: 1,
                      color: const Color(0xFFD0D5DD),
                    ),
                    const Gap(12),
                    Expanded(
                      child: _buildPriceInput(
                        context,
                        label: 'Maximum',
                        controller: _maxController,
                        icon: Iconsax.arrow_up_1,
                        onChanged: (value) {
                          final parsed = _parseFormattedNumber(value);
                          final clamped = parsed.clamp(
                            FilterHandler.minPrice,
                            _maxPriceLimit.toInt(),
                          );
                          FilterHandler.maxPrice =
                              ((clamped / _priceStep).round() * _priceStep)
                                  .toInt();
                          setState(() {});
                        },
                        onEditingComplete: () {
                          _maxController.text =
                              _format.format(FilterHandler.maxPrice);
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(16),

                // Slider
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: const Color(0xFFF2F4F7),
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withValues(alpha: 0.1),
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    trackHeight: 4,
                  ),
                  child: RangeSlider(
                    values: RangeValues(
                      FilterHandler.minPrice.toDouble(),
                      FilterHandler.maxPrice.toDouble(),
                    ),
                    min: _minPriceLimit,
                    max: _maxPriceLimit,
                    divisions: _maxPriceLimit.toInt(),
                    labels: RangeLabels(
                      '${_format.format(FilterHandler.minPrice)} F',
                      FilterHandler.maxPrice >= _maxPriceLimit
                          ? '${_format.format(_maxPriceLimit.toInt())}+ F'
                          : '${_format.format(FilterHandler.maxPrice)} F',
                    ),
                    onChanged: (values) {
                      setState(() {
                        FilterHandler.minPrice =
                            ((values.start / _priceStep).round() * _priceStep)
                                .toInt();
                        FilterHandler.maxPrice =
                            ((values.end / _priceStep).round() * _priceStep)
                                .toInt();
                        _updateControllersFromSlider();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildPriceInput(
  BuildContext context, {
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required ValueChanged<String> onChanged,
  required VoidCallback onEditingComplete,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFF2F4F7)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF344054),
                    ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  // Ajoutez ces deux lignes :
                  filled: true,
                  fillColor: Colors.transparent,
                  suffixText: ' F',
                  suffixStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667085),
                  ),
                ),
                onChanged: onChanged,
                onEditingComplete: onEditingComplete,
                onTapOutside: (_) => onEditingComplete(),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}