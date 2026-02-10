import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class CustomPinput extends StatelessWidget {
  const CustomPinput({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.focusNode,
    this.width = 45,
    this.height = 45,
    this.fontSize = 20,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.backgroundColor,
  });

  final TextEditingController controller;
  final int length;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final bool enabled;
  final String? errorText;
  final FocusNode? focusNode;
  final double width;
  final double height;
  final double fontSize;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = errorText != null && errorText!.isNotEmpty;

    final defaultPinTheme = PinTheme(
      width: width,
      height: height,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasError
              ? (errorBorderColor ?? Colors.red)
              : (borderColor ?? theme.colorScheme.primary.withOpacity(.5)),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: hasError
              ? (errorBorderColor ?? Colors.red)
              : (focusedBorderColor ?? theme.colorScheme.primary),
          width: 1,
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: errorBorderColor ?? Colors.red,
          width: 1,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Pinput(
          length: length,
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onCompleted: onCompleted,
          onChanged: onChanged,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          errorPinTheme: hasError ? errorPinTheme : null,
          forceErrorState: hasError,
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 24,
                height: 2,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: TextStyle(
                color: errorBorderColor ?? Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
