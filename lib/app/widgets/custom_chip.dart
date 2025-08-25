import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry trainlingPadding;
  final IconData? icon;
  final double iconSize;
  final String label;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry iconPadding;
  final Widget? trailing;
  final void Function()? onTap;

  const CustomChip({
    super.key,
    this.backgroundColor = Colors.grey,
    this.iconColor = Colors.black,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    this.icon,
    this.iconSize = 20,
    this.label = '',
    this.labelStyle,
    this.iconPadding = const EdgeInsets.only(right: 2),
    this.trailing,
    this.trainlingPadding = const EdgeInsets.only(left: 2),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: icon != null,
              child: Padding(
                padding: iconPadding,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
            ),
            Text(
              label,
              maxLines: 1,
              style: labelStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
            Visibility(
              visible: trailing != null,
              child: Padding(
                padding: trainlingPadding,
                child: trailing,
              ),
            )
          ],
        ),
      ),
    );
  }
}
