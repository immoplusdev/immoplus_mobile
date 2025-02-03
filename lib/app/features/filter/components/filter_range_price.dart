import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class FilterRangePrice extends StatefulWidget {
  const FilterRangePrice({super.key});

  @override
  State<FilterRangePrice> createState() => _FilterRangePriceState();
}

class _FilterRangePriceState extends State<FilterRangePrice> {
  double _minPrice = 10000;
  double _maxPrice = 300000;
  final double _priceStep = 5000;
  final double _maxPriceLimit = 3000000;

  final NumberFormat _format = NumberFormat.decimalPattern('fr_FR');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Fourchette de prix',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          // Slider and Values
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.scafold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 5000,
                    max: _maxPriceLimit,
                    divisions: ((_maxPriceLimit - 5000) / _priceStep).round(),
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey.shade300,
                    labels: RangeLabels(
                      '${_format.format(_minPrice.toInt())} F',
                      _maxPrice >= _maxPriceLimit
                          ? '3,000,000+ F'
                          : '${_format.format(_maxPrice.toInt())} F',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minPrice =
                            (values.start / _priceStep).round() * _priceStep;
                        _maxPrice =
                            (values.end / _priceStep).round() * _priceStep;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  // Display min and max values
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Minimum',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_format.format(_minPrice.toInt())} F',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Maximum',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _maxPrice >= _maxPriceLimit
                                  ? '3,000,000+ F'
                                  : '${_format.format(_maxPrice.toInt())} F',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
