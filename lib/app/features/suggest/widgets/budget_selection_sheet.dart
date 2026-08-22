import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class BudgetSelectionSheet extends StatefulWidget {
  final double initialMin;
  final double initialMax;

  const BudgetSelectionSheet({
    super.key,
    required this.initialMin,
    required this.initialMax,
  });

  static Future<({double min, double max})?> show(
      BuildContext context, double initialMin, double initialMax) {
    return showModalBottomSheet<({double min, double max})>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: BudgetSelectionSheet(
              initialMin: initialMin, initialMax: initialMax),
        ),
      ),
    );
  }

  @override
  State<BudgetSelectionSheet> createState() => _BudgetSelectionSheetState();
}

class _BudgetSelectionSheetState extends State<BudgetSelectionSheet> {
  late double _tMin;
  late double _tMax;

  late TextEditingController _minController;
  late TextEditingController _maxController;

  final _formatter = NumberFormat('#,###', 'fr_FR');

  String _formatPrice(double value) {
    return '${_formatter.format(value.toInt())} F';
  }

  @override
  void initState() {
    super.initState();
    _tMin = widget.initialMin;
    _tMax = widget.initialMax > 0 ? widget.initialMax : 200000;
    _minController = TextEditingController(text: _tMin.toInt().toString());
    _maxController = TextEditingController(text: _tMax.toInt().toString());
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    _minController.text = _tMin.toInt().toString();
    _maxController.text = _tMax.toInt().toString();
  }

  void _onMinChanged(String val) {
    final clean = val.replaceAll(RegExp(r'\D'), '');
    final parsed = double.tryParse(clean) ?? 0;
    setState(() {
      _tMin = parsed.clamp(0, 200000);
    });
  }

  void _onMaxChanged(String val) {
    final clean = val.replaceAll(RegExp(r'\D'), '');
    final parsed = double.tryParse(clean) ?? 0;
    setState(() {
      _tMax = parsed.clamp(0, 200000);
    });
  }

  void _submit() {
    final rawMin = _minController.text.replaceAll(RegExp(r'\D'), '');
    final rawMax = _maxController.text.replaceAll(RegExp(r'\D'), '');

    double finalMin = (double.tryParse(rawMin) ?? _tMin).clamp(0.0, 200000.0);
    double finalMax = (double.tryParse(rawMax) ?? _tMax).clamp(0.0, 200000.0);

    if (finalMin > finalMax) {
      final temp = finalMin;
      finalMin = finalMax;
      finalMax = temp;
    }

    Navigator.pop(context, (min: finalMin, max: finalMax));
  }

  Widget _buildBudgetChoice(double minVal, double maxVal, String label) {
    bool isSelected = _tMin == minVal && _tMax == maxVal;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.black,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side:
            BorderSide(color: isSelected ? Colors.black : Colors.grey.shade300),
      ),
      onSelected: (_) {
        setState(() {
          _tMin = minVal;
          _tMax = maxVal;
          _updateControllers();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final validMin = _tMin.clamp(0.0, 200000.0);
    final validMax =
        _tMax >= validMin ? _tMax.clamp(validMin, 200000.0) : validMin;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quel budget pour les nuits ?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Quick selection chips with clear "k" notations
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              _buildBudgetChoice(0, 15000, '< 15k'),
              _buildBudgetChoice(0, 20000, '< 20k'),
              _buildBudgetChoice(0, 40000, '< 40k'),
              _buildBudgetChoice(40000, 80000, '40k - 80k'),
              _buildBudgetChoice(80000, 150000, '80k - 150k'),
              _buildBudgetChoice(150000, 200000, '150k +'),
            ],
          ),
          const SizedBox(height: 24),

          // Manual price entry fields
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    labelText: 'Budget min (F)',
                    labelStyle:
                        TextStyle(color: AppColors.primary, fontSize: 13),
                    hintText: 'ex: 30000',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
                    ),
                    isDense: true,
                  ),
                  onChanged: _onMinChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _maxController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    labelText: 'Budget max (F)',
                    labelStyle:
                        TextStyle(color: AppColors.primary, fontSize: 13),
                    hintText: 'ex: 150000',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
                    ),
                    isDense: true,
                  ),
                  onChanged: _onMaxChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Price Slider
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: Colors.grey.shade200,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.1),
                  trackHeight: 4,
                  rangeThumbShape:
                      const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
                  rangeValueIndicatorShape:
                      const PaddleRangeSliderValueIndicatorShape(),
                  valueIndicatorColor: AppColors.primary,
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  showValueIndicator: ShowValueIndicator.onDrag,
                ),
                child: RangeSlider(
                  values: RangeValues(validMin, validMax),
                  min: 0,
                  max: 200000,
                  labels: RangeLabels(
                    _formatPrice(validMin),
                    validMax >= 200000
                        ? '${_formatPrice(validMax)}+'
                        : _formatPrice(validMax),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _tMin = val.start;
                      _tMax = val.end;
                      _updateControllers();
                    });
                  },
                ),
              ),
              // Min/Max labels under slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0 F',
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    Text(
                      '200 000 F+',
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomButtom(
            text: 'Continuer',
            onClick: _submit,
          )
        ],
      ),
    );
  }
}
