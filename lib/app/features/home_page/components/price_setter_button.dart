import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';

class PriceSetterButton extends StatelessWidget {
  const PriceSetterButton({
    super.key,
    required this.title,
    required this.amount,
    required this.onMinus,
    required this.onPlus,
    required this.onTapUp,
    required this.onTapMinus,
    required this.onTapPlus,
  });
  final String title;
  final int amount;
  final void Function(TapDownDetails)? onPlus;
  final void Function(TapDownDetails)? onMinus;
  final Function(TapUpDetails)? onTapUp;
  final void Function()? onTapPlus;
  final void Function()? onTapMinus;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                InkWell(
                  onTapDown: onMinus,
                  onTapUp: onTapUp,
                  onTap: onTapMinus,
                  onTapCancel: () => onTapUp,
                  child: Container(
                    height: double.infinity,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      border: const Border(
                        right: BorderSide(),
                      ),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.minus,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(Utils.formatCurrency(amount)),
                    ],
                  ),
                ),
                InkWell(
                  onTapDown: onPlus,
                  onTapUp: onTapUp,
                  onTap: onTapPlus,
                  child: Container(
                    height: double.infinity,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      border: const Border(
                        left: BorderSide(),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.plus,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
