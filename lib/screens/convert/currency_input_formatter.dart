import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// credits to Mr Jorge Viera @ stack overflow:
// https://stackoverflow.com/questions/50395032/flutter-textfield-with-currency-format
class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    } else if (newValue.text.endsWith('.')) {
      return newValue;
    }

    double value = double.parse(newValue.text.replaceAll(',', ''));
    final formatted = formatValue(value);

    return newValue.copyWith(
        text: formatted,
        selection: new TextSelection.collapsed(offset: formatted.length));
  }

  static String formatValue(double value) {
    final locale = Intl.getCurrentLocale();
    NumberFormat format;
    if (value < 100) {
      format = NumberFormat('###,###.##', locale);
    } else if (value < 10000) {
      format = NumberFormat('###,###', locale);
    } else {
      // if we have a number above 10k
      // it's better we start removing insignificant numbers
      value = (value / 100.0).roundToDouble() * 100.0;
      format = NumberFormat('###,###', locale);
    }

    return format.format(value);
  }
}
