import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/app_colors.dart';

const _buttonHeight = 50.0;

class CustomButtom extends StatelessWidget {
  const CustomButtom(
      {super.key,
      this.text,
      this.child,
      this.onClick,
      this.clickable = true,
      this.color,
      this.textColor,
      this.fontSize,
      this.elevation,
      this.isLoading = false,
      this.borderRadius,
      this.buttonHeight});
  final String? text;
  final Widget? child;
  final void Function()? onClick;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? elevation;
  final bool clickable;
  final bool isLoading;
  final double? buttonHeight;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: buttonHeight ?? _buttonHeight,
        //padding: EdgeInsets.only(left: 30, right: 30),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: elevation ?? 0,
            backgroundColor: (clickable)
                ? (color == null)
                    ? AppColors.primary
                    : color
                : Colors.grey[400],
            shape: RoundedRectangleBorder(
                borderRadius:
                    borderRadius ?? BorderRadius.circular(radiusButton)),
          ),
          onPressed: isLoading
              ? null
              : (clickable)
                  ? onClick
                  : null,
          child: isLoading
              ? CupertinoActivityIndicator()
              : child ??
                  Text(
                    text ?? "",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: textColor ?? Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
        ),
      ),
    );
  }
}
