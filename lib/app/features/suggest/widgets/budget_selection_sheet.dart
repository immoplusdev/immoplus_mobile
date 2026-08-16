import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

class BudgetSelectionSheet extends StatefulWidget {
  final double initialMin;
  final double initialMax;

  const BudgetSelectionSheet(
      {super.key, required this.initialMin, required this.initialMax});

  static Future<({double min, double max})?> show(
      BuildContext context, double initialMin, double initialMax) {
    return showModalBottomSheet<({double min, double max})>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) =>
          BudgetSelectionSheet(initialMin: initialMin, initialMax: initialMax),
    );
  }

  @override
  State<BudgetSelectionSheet> createState() => _BudgetSelectionSheetState();
}

class _BudgetSelectionSheetState extends State<BudgetSelectionSheet> {
  late double _tMin;
  late double _tMax;

  @override
  void initState() {
    super.initState();
    _tMin = widget.initialMin;
    _tMax = widget.initialMax;
  }

  Widget _buildBudgetChoice(double minVal, double maxVal, String label) {
    bool isSelected = _tMin == minVal && _tMax == maxVal;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.black,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quel budget pour les nuits ?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              _buildBudgetChoice(0, 40000, '-40.000 fr'),
              _buildBudgetChoice(40000, 80000, '40 - 80.000 fr'),
              _buildBudgetChoice(80000, 150000, '80 - 150.000 fr'),
              _buildBudgetChoice(150000, 200000, '150.000 fr +'),
            ],
          ),
          const SizedBox(height: 32),
          RangeSlider(
            values: RangeValues(_tMin, _tMax),
            min: 0,
            max: 200000,
            divisions: 20,
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() {
                _tMin = val.start;
                _tMax = val.end;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomButtom(
            text: 'Continuer',
            onClick: () => Navigator.pop(context, (min: _tMin, max: _tMax)),
          )
        ],
      ),
    );
  }
}
