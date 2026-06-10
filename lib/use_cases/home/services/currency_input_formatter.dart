import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// credits to Mr Jorge Viera @ stack overflow:
// https://stackoverflow.com/questions/50395032/flutter-textfield-with-currency-format
class CurrencyInputFormatter extends TextInputFormatter {
  final FilteringTextInputFormatter whiteListingFormatter =
      FilteringTextInputFormatter(RegExp(r'[\d\.,]+'), allow: true);

  static final RegExp _convertRegex = RegExp(r'[^.\d]');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text == newValue.text) {
      return newValue;
    }

    newValue = whiteListingFormatter.formatEditUpdate(oldValue, newValue);

    // If a comma has been entered, treat it as a decimal
    // the comma input is an issue with the iOS 10 update
    var newText = newValue.text.replaceAll(RegExp(',\$'), '.');

    // Split anything below the decimal and join afterwards
    String newFormatted;
    if (newText.contains('.')) {
      var parts = newValue.text.split('.');
      var real = parts[0];
      var decimal = parts.length > 1 ? parts[1] : '';
      newFormatted = '${formatted(real)}.$decimal';
    } else {
      newFormatted = formatted(newText);
    }

    return newValue.copyWith(
        text: newFormatted,
        selection: TextSelection(
            baseOffset: newFormatted.length,
            extentOffset: newFormatted.length));
  }

  String formatted(String input) {
    // If we can't determine it's value we can't format it either
    final value = double.tryParse(input.replaceAll(',', ''));
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

  /// Groups a single raw ASCII numeric token (digits, an optional single `.`
  /// and optional decimals) with locale-aware separators for display.
  ///
  /// Unlike [formatValue] this preserves exactly what was typed: it never
  /// rounds, keeps a trailing dot and trailing zeros, and only strips leading
  /// zeros. It is intended for live formatting of on-screen keypad input where
  /// the raw string remains the source of truth.
  static String formatGrouped(String rawNumber) {
    final symbols = NumberFormat('#,##0.#', Intl.getCurrentLocale()).symbols;
    final dotIndex = rawNumber.indexOf('.');
    var intPart = dotIndex == -1 ? rawNumber : rawNumber.substring(0, dotIndex);
    intPart = intPart.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final groupedInt = intPart.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}${symbols.GROUP_SEP}');
    if (dotIndex == -1) {
      return groupedInt;
    }
    return '$groupedInt${symbols.DECIMAL_SEP}${rawNumber.substring(dotIndex + 1)}';
  }

  static double? toDouble(String value) {
    return double.tryParse(value.replaceAll(_convertRegex, ''));
  }
}
