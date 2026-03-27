import 'package:flutter/material.dart';
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

  final NumberFormat _format = NumberFormat.decimalPattern('fr_FR');

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
                // Min / Max display
                Row(
                  children: [
                    Expanded(
                      child: _buildPriceBox(
                        context,
                        label: 'Minimum',
                        value: '${_format.format(FilterHandler.minPrice)} F',
                        icon: Iconsax.arrow_down_1,
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
                      child: _buildPriceBox(
                        context,
                        label: 'Maximum',
                        value: FilterHandler.maxPrice >= _maxPriceLimit
                            ? '${_format.format(_maxPriceLimit.toInt())}+ F'
                            : '${_format.format(FilterHandler.maxPrice)} F',
                        icon: Iconsax.arrow_up_1,
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
                    values: RangeValues(FilterHandler.minPrice.toDouble(),
                        FilterHandler.maxPrice.toDouble()),
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

  Widget _buildPriceBox(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          const Gap(4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF344054),
                ),
          ),
        ],
      ),
    );
  }
}
