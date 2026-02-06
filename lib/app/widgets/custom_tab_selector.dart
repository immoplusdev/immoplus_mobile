import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class CustomTabSelector extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final Function(int) onTabSelected;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;

  const CustomTabSelector({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.onTabSelected,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? AppColors.blue65BAF0;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.ECECEC,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 48,
                decoration: BoxDecoration(
                  color: selectedIndex == index ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: selectedIndex == index
                              ? Colors.white
                              : unselectedColor ?? Colors.black,
                          fontWeight: selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 16,
                        ),
                    child: Text(
                      tabs[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
