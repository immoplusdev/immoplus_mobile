import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class CustomColorSelector extends StatelessWidget {
  CustomColorSelector(
      {super.key,
      required this.color,
      required this.isSelected,
      this.onPressed});
  Color color;
  bool isSelected;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: isSelected ? 35 : 27,
        height: isSelected ? 35 : 27,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(60),
          border: (isSelected)
              ? Border.all(width: 2, color: AppColors.white)
              : Border.all(
                  color: AppColors.transparent,
                  width: 0,
                ),
          boxShadow: [
            (isSelected)
                ? const BoxShadow(
                    color: AppColors.shadowBEBEBE,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 0), // changes position of shadow
                  )
                : const BoxShadow(),
          ],
        ),
      ),
    );
  }
}
