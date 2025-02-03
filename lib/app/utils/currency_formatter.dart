import 'package:flutter/services.dart';

class CurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String value = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    int offset = value.length % 3;

    for (int i = 0; i < value.length; i++) {
      if (i != 0 && (i - offset) % 3 == 0) {
        buffer.write(' '); // Add space character as thousand separator
      }
      buffer.write(value[i]);
    }

    String newText = buffer.toString();
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String format(String value) {
    value = value.replaceAll(' ', ''); // Remove existing spaces
    final buffer = StringBuffer();
    int offset = value.length % 3;

    for (int i = 0; i < value.length; i++) {
      if (i != 0 && (i - offset) % 3 == 0) {
        buffer.write(' '); // Add space character as thousand separator
      }
      buffer.write(value[i]);
    }

    return buffer.toString();
  }
}
