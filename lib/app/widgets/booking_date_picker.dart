import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_text_field.dart';

class BookingdatePicker extends StatefulWidget {
  const BookingdatePicker({
    Key? key,
    required this.labelText,
    // required this.validator,
    required this.controller,
    required this.getValue,
  }) : super(key: key);
  final String labelText;
  // final String? Function(String?)? validator;
  final void Function(List<DateTime>?) getValue;
  final TextEditingController controller;

  @override
  _BookingdatePickerState createState() => _BookingdatePickerState();
}

class _BookingdatePickerState extends State<BookingdatePicker> {
  List<DateTime?> _dates = [
    // DateTime(2023, 08, 1, 15, 30),
    // DateTime(2023, 08, 5, 15, 30),
    // DateTime(2023, 08, 20, 15, 30),
    // DateTime(2023, 08, 24, 15, 30)
  ];
  DateFormat formatDate = DateFormat('d MMMM');
  List<DateTime> valueToSend = [];
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
      //fontSize: 13,
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

      onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          insetPadding: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SizedBox(
            width: 500,
            height: 400,
            child: CalendarDatePicker2WithActionButtons(
              config: CalendarDatePicker2WithActionButtonsConfig(
                closeDialogOnOkTapped: true,
                firstDayOfWeek: 1,
                calendarType: CalendarDatePicker2Type.multi,
                selectedDayTextStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                //selectedDayHighlightColor: Colors.purple[800],
                centerAlignModePicker: true,
                // customModePickerIcon: Icon(Icons.push_pin_outlined),
                //   dayBuilder: _yourDayBuilder,
                //   yearBuilder: _yourYearBuilder,
              ),
              value: _dates,
              onValueChanged: (dates) {
                widget.controller.text = "";
                _dates = dates;
                //log(_dates.toString());
                widget.getValue(_dates.cast<DateTime>());
                _dates.forEach((e) {
                  widget.controller.text += "${formatDate.format(e!)}, ";
                });

                Navigator.pop(context);
                // widget.controller.text =
                //     "du ${formatDate.format(_dates[0]!)} au ${formatDate.format(_dates[1]!)}";
              },
            ),
          ),
          // actions: <Widget>[
          //   TextButton(
          //     onPressed: () => Navigator.pop(context, 'Cancel'),
          //     child: const Text('Cancel'),
          //   ),
          //   TextButton(
          //     onPressed: () => Navigator.pop(context, 'OK'),
          //     child: const Text('OK'),
          //   ),
          // ],
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
