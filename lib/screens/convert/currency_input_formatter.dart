import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// credits to Mr Jorge Viera @ stack overflow:
// https://stackoverflow.com/questions/50395032/flutter-textfield-with-currency-format
class CurrencyInputFormatter extends TextInputFormatter {

  final WhitelistingTextInputFormatter whiteListingFormatter = new WhitelistingTextInputFormatter(new RegExp(r'[\d\.,]+'));

  void log(String prefix, TextEditingValue val) {
    print('${prefix} ${val.text} selection ${val.selection.baseOffset}-${val.selection.extentOffset}');
  }

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    sleep(new Duration(milliseconds: 50));
    if (oldValue.text == newValue.text) {
      return newValue;
    }
    print('');
    log('old', oldValue);
    log('new', newValue);
    //return newValue;

    newValue = whiteListingFormatter.formatEditUpdate(oldValue, newValue);

    // Split anything below the decimal and join afterwards
    String newFormatted;
    if (newValue.text.contains('.')) {
      var parts = newValue.text.split('.');
      var real = parts[0];
      var decimal = parts[1];
      newFormatted = formatted(real) + '.' + decimal;
    } else {
      newFormatted = formatted(newValue.text);
    }

//    var result = new TextEditingValue(
//        text: newFormatted,
//        selection: TextSelection(baseOffset: newFormatted.length, extentOffset: newFormatted.length)
//    );
//    log('res', result);
//    return result;
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
    NumberFormat format;
//    if (value < 100) {
//      format = NumberFormat('###,###.##', locale);
//    } else if (value < 10000) {
//      format = NumberFormat('###,###', locale);
//    } else {
//      // if we have a number above 10k
//      // it's better we start removing insignificant numbers
//      value = (value / 100.0).roundToDouble() * 100.0;
//      format = NumberFormat('###,###', locale);
//    }s
    format = NumberFormat('###,###.##', locale);

    return format.format(value);
  }
}
