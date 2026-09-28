import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';

class CustomDropDownField extends StatelessWidget {
  CustomDropDownField({
    super.key,
    this.labelText,
    this.sufixIcon,
    this.onTap,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.onChanged,
    required this.items,
    this.value,
  });
  final String? labelText;
  final Widget? sufixIcon;
  final List<String> items;
  final Function()? onTap;
  Function(String?)? onSaved;
  Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  void Function(String?)? onChanged;
  String? value;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((label) => DropdownMenuItem(
                value: label,
                child: Text(label.toString()),
              ))
          .toList(),
      onSaved: onSaved,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: labelText ?? 'label',
        filled: true,
        focusColor: Theme.of(context).colorScheme.onSurface,
        suffixIcon: sufixIcon,
        errorStyle: AppTypography.font(color: AppColors.red600),
        contentPadding: const EdgeInsets.all(0).copyWith(left: 10),
        hintStyle: AppTypography.font(
          color: AppColors.gray500,
          fontSize: 15,
        ),
        //fillColor: _color,
        //focusColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
