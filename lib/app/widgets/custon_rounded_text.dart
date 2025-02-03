import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomRoundedTextField extends StatelessWidget {
  final String? labelText;
  final double height;
  final TextInputAction? textInputAction;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final Widget? sufixIcon;
  final Widget? prefixIcon;
  final Function()? onTap;
  Function(String?)? onSaved;
  Function(String)? onFieldSubmitted;
  TextEditingController? controller = TextEditingController(text: '');
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool obscureText;

  CustomRoundedTextField({
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
  Widget build(BuildContext context) {
    const errorStyle = TextStyle(
      fontSize: 14,
    );

    // Wrap everything in LayoutBuilder so that the available maxWidth is taken into account for the height calculation (important if you error text exceeds one line)
    return LayoutBuilder(builder: (context, constraints) {
      // Use tp to calculate the height of the errorText
      final textPainter = TextPainter()
        ..text = const TextSpan(text: ' ', style: errorStyle)
        ..textDirection = TextDirection.ltr
        ..layout(maxWidth: constraints.maxWidth);

      final heightErrorMessage = textPainter.size.height + 8;
      return Stack(
        children: [
          // Separate container with identical height of text field which is placed behind the actual textfield

          const SizedBox(
            width: 400,
            height: 10,
          ),
          Container(
            height: height,
            margin: const EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 166, 173, 185),
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
            // Add height of error message if it is displayed
            height: validator != null ? height + heightErrorMessage : height,
            margin: const EdgeInsets.only(left: 5, right: 5),
            //padding: EdgeInsets.all(5),
            //padding: EdgeInsets.all(8),
            child: TextFormField(
              onChanged: ((value) {}),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validator,
              obscureText: obscureText,
              minLines: minLines,
              maxLines: maxLines,
              controller: controller,
              textInputAction: textInputAction,
              onTap: onTap,
              onSaved: onSaved,
              onFieldSubmitted: onFieldSubmitted,
              keyboardType: textInputType,
              cursorColor: Theme.of(context).colorScheme.onSurface,
              cursorRadius: const Radius.circular(5),
              focusNode: focusNode,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(18),

                prefixText: prefixText,
                //labelText: labelText!,
                prefixIcon: prefixIcon,
                iconColor: Colors.black,
                hintText: labelText!,
                filled: true,

                fillColor: Colors.white,
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
                focusColor: Theme.of(context).colorScheme.onSurface,
                suffixIcon: sufixIcon,
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

class CustomRoundedTextFieldTT extends StatelessWidget {
  CustomRoundedTextFieldTT({
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
  final String? labelText;
  final Widget? sufixIcon;
  final Widget? prefixIcon;
  final Function()? onTap;
  Function(String?)? onSaved;
  Function(String)? onFieldSubmitted;
  TextEditingController? controller = TextEditingController(text: '');
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contrains) {
      return Stack(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
          ),
          Container(
            //margin: EdgeInsets.only(bottom: 10),
            //height: 55,
            child: TextFormField(
              onChanged: ((value) {}),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validator,
              obscureText: obscureText,
              minLines: minLines,
              maxLines: maxLines,
              controller: controller,
              textInputAction: textInputAction,
              onTap: onTap,
              onSaved: onSaved,
              onFieldSubmitted: onFieldSubmitted,
              keyboardType: textInputType,
              cursorColor: Theme.of(context).colorScheme.onSurface,
              cursorRadius: const Radius.circular(5),
              focusNode: focusNode,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(18),

                prefixText: prefixText,
                //labelText: labelText!,
                prefixIcon: prefixIcon,
                iconColor: Colors.black,
                hintText: labelText!,
                filled: true,

                fillColor: Colors.white,
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
                focusColor: Theme.of(context).colorScheme.onSurface,
                suffixIcon: sufixIcon,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      );
    });
  }
}
