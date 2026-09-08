import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class CustomRoundedTextField extends StatefulWidget {
  final String? labelText;
  final double height;
  final TextInputAction? textInputAction;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final Widget? sufixIcon;
  final Widget? prefixIcon;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool obscureText;

  const CustomRoundedTextField({
    super.key,
    this.labelText,
    this.sufixIcon,
    this.onTap,
    this.onSaved,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.prefixText,
    this.prefixIcon,
    this.obscureText = false,
    this.height = 60,
  });

  @override
  State<CustomRoundedTextField> createState() => _CustomRoundedTextFieldState();
}

class _CustomRoundedTextFieldState extends State<CustomRoundedTextField> {
  TextEditingController? _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void didUpdateWidget(CustomRoundedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller && widget.controller != null) {
      _internalController?.dispose();
      _internalController = null;
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const errorStyle = TextStyle(
      fontSize: 14,
    );

    return LayoutBuilder(builder: (context, constraints) {
      final textPainter = TextPainter()
        ..text = const TextSpan(text: ' ', style: errorStyle)
        ..textDirection = TextDirection.ltr
        ..layout(maxWidth: constraints.maxWidth);

      final heightErrorMessage = textPainter.size.height + 8;
      return Stack(
        children: [
          const SizedBox(
            width: 400,
            height: 10,
          ),
          Container(
            height: widget.height,
            margin: const EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowA6ADB9,
                  blurRadius: 8,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(
                60.0,
              ),
            ),
          ),
          Container(
            height: widget.validator != null
                ? widget.height + heightErrorMessage
                : widget.height,
            margin: const EdgeInsets.only(left: 5, right: 5),
            child: TextFormField(
              onChanged: ((value) {}),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: widget.validator,
              obscureText: widget.obscureText,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              controller: _effectiveController,
              textInputAction: widget.textInputAction,
              onTap: widget.onTap,
              onSaved: widget.onSaved,
              onFieldSubmitted: widget.onFieldSubmitted,
              keyboardType: widget.textInputType,
              cursorColor: Theme.of(context).colorScheme.onSurface,
              cursorRadius: const Radius.circular(5),
              focusNode: widget.focusNode,
              inputFormatters: widget.inputFormatters,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(18),
                prefixText: widget.prefixText,
                prefixIcon: widget.prefixIcon,
                iconColor: AppColors.black,
                hintText: widget.labelText ?? '',
                filled: true,
                fillColor: AppColors.white,
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
                focusColor: Theme.of(context).colorScheme.onSurface,
                suffixIcon: widget.sufixIcon,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(
                    60.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(
                    60.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class CustomRoundedTextFieldTT extends StatefulWidget {
  final String? labelText;
  final Widget? sufixIcon;
  final Widget? prefixIcon;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool obscureText;

  const CustomRoundedTextFieldTT({
    super.key,
    this.labelText,
    this.sufixIcon,
    this.onTap,
    this.onSaved,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.prefixText,
    this.prefixIcon,
    this.obscureText = false,
  });

  @override
  State<CustomRoundedTextFieldTT> createState() =>
      _CustomRoundedTextFieldTTState();
}

class _CustomRoundedTextFieldTTState extends State<CustomRoundedTextFieldTT> {
  TextEditingController? _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void didUpdateWidget(CustomRoundedTextFieldTT oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller && widget.controller != null) {
      _internalController?.dispose();
      _internalController = null;
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: AppColors.black,
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
          ),
          TextFormField(
            onChanged: ((value) {}),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            obscureText: widget.obscureText,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            controller: _effectiveController,
            textInputAction: widget.textInputAction,
            onTap: widget.onTap,
            onSaved: widget.onSaved,
            onFieldSubmitted: widget.onFieldSubmitted,
            keyboardType: widget.textInputType,
            cursorColor: Theme.of(context).colorScheme.onSurface,
            cursorRadius: const Radius.circular(5),
            focusNode: widget.focusNode,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(18),
              prefixText: widget.prefixText,
              prefixIcon: widget.prefixIcon,
              iconColor: AppColors.black,
              hintText: widget.labelText ?? '',
              filled: true,
              fillColor: AppColors.white,
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
              focusColor: Theme.of(context).colorScheme.onSurface,
              suffixIcon: widget.sufixIcon,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ],
      );
    });
  }
}
