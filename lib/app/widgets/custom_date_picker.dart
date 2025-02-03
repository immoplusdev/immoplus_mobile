import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_text_field.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    Key? key,
    required this.labelText,
    // required this.validator,
    required this.controller,
    required this.getValue,
  }) : super(key: key);
  final String labelText;
  // final String? Function(String?)? validator;
  final void Function(String?) getValue;
  final TextEditingController controller;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateFormat formatDate = DateFormat('d MMMM yyyy à hh:mm');
  String valueToSend = '';
  void onChange(String val) {
    setState(() {
      widget.controller.text = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      fontSize: 11,
      prefixIcon: Icon(CupertinoIcons.calendar),
      controller: widget.controller,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return 'veillez entrer une date';
        }
        widget.getValue(valueToSend);
        return null;
      },
      labelText: widget.labelText,
      focusNode: AlwaysDisabledFocusNode(),
      onTap: () async {
        final ThemeData theme = Theme.of(context);

        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2024),
          //locale: Locale('fr'),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  // Change the primary color
                  onPrimary: Colors.black, // Change the text color on primary
                  onSurface: Colors.black, // Change the text color on surface
                ),
              ),
              child: child!,
            );
          },
          //locale: Locale('fr'),
        );

        if (pickedDate != null) {
          // ignore: use_build_context_synchronously
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    surface: Theme.of(context).colorScheme.onPrimary,
                    // Change the primary color
                    // surface: Colors.white,
                    // background: Colors.white,
                    // onPrimary: Colors.black, // Change the text color on primary
                    // onSurface: Colors.black, // Change the text color on surface
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedTime != null) {
            print(pickedTime.hour);
            DateTime dateTime = DateTime(pickedDate.year, pickedDate.month,
                pickedDate.day, pickedTime.hour, pickedTime.minute);

            setState(() {
              valueToSend = dateTime.toIso8601String();
              widget.controller.text = formatDate.format(dateTime);
            });
          }
        }
        // DatePicker.showDatePicker(context,
        //     showTitleActions: true, minTime: DateTime.now(),
        //     //maxTime: DateTime(2019, 6, 7),
        //     onChanged: (date) {
        //   onChange(date.toString());
        // }, onConfirm: (date) {
        //   onChange(date.toString());
        // }, currentTime: DateTime.now(), locale: LocaleType.fr);
      },
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
