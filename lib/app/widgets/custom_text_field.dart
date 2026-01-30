import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
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
    this.fontSize,
    this.fillColor,
    this.autofocus = false,
    this.isEnabled = true,
  });
  final String? labelText;
  final Widget? sufixIcon;
  final Widget? prefixIcon;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final Function(String)? onFieldSubmitted;
  TextEditingController? controller = TextEditingController(text: '');
  final FocusNode? focusNode;
  final int minLines;
  final int? maxLines;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool obscureText;
  final double? fontSize;
  final Color? fillColor;
  final bool? autofocus;
  final bool isEnabled;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _textFieldFocus = FocusNode();
  Color _color = const Color.fromARGB(158, 234, 234, 234);
  Color _iconColor = const Color.fromARGB(236, 74, 74, 74);
  @override
  void initState() {
    _textFieldFocus.addListener(() {
      if (_textFieldFocus.hasFocus) {
        setState(() {
          _color = HexColor('#2072ca').withOpacity(0.1);
          _iconColor = HexColor('#2072ca');
        });
      } else {
        setState(() {
          _color = const Color.fromARGB(158, 234, 234, 234);
          _iconColor = const Color.fromARGB(236, 74, 74, 74);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        enabled: widget.isEnabled,
        style: (widget.fontSize != null)
            ? TextStyle(fontSize: widget.fontSize)
            : null,
        // enableInteractiveSelection: !widget.readOnly,
        autofocus: widget.autofocus ?? false,
        onChanged: ((value) {}),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        obscureText: widget.obscureText,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        onTap: widget.onTap,
        onSaved: widget.onSaved,
        onFieldSubmitted: widget.onFieldSubmitted,
        keyboardType: widget.textInputType,
        cursorColor: Theme.of(context).colorScheme.onSurface,
        cursorRadius: const Radius.circular(5),
        //focusNode: widget.focusNode,
        inputFormatters: widget.inputFormatters,
        cursorHeight: 16,
        focusNode: _textFieldFocus,
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.redAccent),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          // prefixIconColor: _iconColor,
          // suffixIconColor: _iconColor,

          prefixText: widget.prefixText,
          //labelText: labelText!,
          prefixIcon: widget.prefixIcon,

          //iconColor: Colors.black,
          hintText: widget.labelText,
          hintStyle: TextStyle(
            color: Colors.grey,
            //fontWeight: FontWeight.bold,
            fontSize: widget.fontSize ?? 15,
          ),
          filled: true,
          fillColor: widget.fillColor,

          //focusColor: Colors.white,
          suffixIcon: widget.sufixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
