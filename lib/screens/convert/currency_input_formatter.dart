import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// credits to Mr Jorge Viera @ stack overflow:
// https://stackoverflow.com/questions/50395032/flutter-textfield-with-currency-format
class CurrencyInputFormatter extends TextInputFormatter {

  final WhitelistingTextInputFormatter whiteListingFormatter = new WhitelistingTextInputFormatter(new RegExp(r'[\d\.,]+'));

  static final RegExp _convertRegex = new RegExp(r'[^\d]');

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    if (oldValue.text == newValue.text) {
      return newValue;
    }

    newValue = whiteListingFormatter.formatEditUpdate(oldValue, newValue);

    // If a comma has been entered, treat it as a decimal
    // the comma input is an issue with the iOS 10 update
    var newText = newValue.text.replaceAll(new RegExp(',\$'), '.');

    // Split anything below the decimal and join afterwards
    String newFormatted;
    if (newText.contains('.')) {
      var parts = newValue.text.split('.');
      var real = parts[0];
      var decimal = parts.length > 1 ? parts[1] : '';
      newFormatted = formatted(real) + '.' + decimal;
    } else {
      newFormatted = formatted(newText);
    }

      return newValue.copyWith(
        text: newFormatted,
          selection: TextSelection(baseOffset: newFormatted.length, extentOffset: newFormatted.length)
      );
  }

  String formatted(String input) {
    // If we can't determine it's value we can't format it either
    double value = double.tryParse(input.replaceAll(',', ''));
    if (value == null) {
      return input;
    }

    return formatValue(value);
  }

  static String formatValue(double value) {
    final locale = Intl.getCurrentLocale();
    NumberFormat format = NumberFormat('###,###.##', locale);
    return format.format(value);
  }

  static double toDouble(String value) {
    return double.tryParse(value.replaceAll(_convertRegex, ''));
  }
}
