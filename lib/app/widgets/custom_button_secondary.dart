import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/app_colors.dart';

const _buttonHeight = 50.0;

class CustomButtonSecondary extends StatelessWidget {
  const CustomButtonSecondary({
    super.key,
    this.text,
    this.child,
    this.onClick,
    this.clickable = true,
    this.color,
    this.textColor,
    this.backgroundColor,
    this.fontSize,
    this.borderWidth,
    this.elevation,
    this.isLoading = false,
    this.borderRadius,
    this.buttonHeight,
  });

  final String? text;
  final Widget? child;
  final VoidCallback? onClick;
  final Color? color;
  final Color? textColor;
  final Color? backgroundColor;
  final double? fontSize;
  final double? borderWidth;
  final double? elevation;
  final bool clickable;
  final bool isLoading;
  final double? buttonHeight;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final borderColor = color ?? AppColors.primary;
    final effectiveTextColor = textColor ?? AppColors.primary;
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(radiusButton);

    return Center(
      child: SizedBox(
        height: buttonHeight ?? _buttonHeight,
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            elevation: elevation ?? 0,
            backgroundColor: backgroundColor ?? Colors.white,
            side: BorderSide(
              color: clickable ? borderColor : Colors.grey[400]!,
              width: borderWidth ?? 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: effectiveBorderRadius,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onPressed: isLoading
              ? null
              : (clickable)
                  ? onClick
                  : null,
          child: isLoading
              ? const CupertinoActivityIndicator()
              : child ??
                  Text(
                    text ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: effectiveTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize ?? 15,
                        ),
                  ),
        ),
      ),
    );
  }
}
