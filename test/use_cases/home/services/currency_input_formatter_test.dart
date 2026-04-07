import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/use_cases/home/services/currency_input_formatter.dart';

void main() {
  var currencyInputFormatter = CurrencyInputFormatter();

  test('can add single digits', () async {
    var oldValue = TextEditingValue(text: '');
    var newValue = TextEditingValue(text: '1');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1');
  });

  test('formats thousands with seperators', () async {
    var oldValue = TextEditingValue(text: '100');
    var newValue = TextEditingValue(text: '1000');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1,000');
  });

  test('formats thousands with seperators but does not round off', () async {
    var oldValue = TextEditingValue(text: '1000');
    var newValue = TextEditingValue(text: '10001');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '10,001');
  });

  test('ignores leading zeros', () async {
    var oldValue = TextEditingValue(text: '0');
    var newValue = TextEditingValue(text: '01');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1');
  });

  test('can delete after input', () async {
    var oldValue = TextEditingValue(text: '1,000');
    var newValue = TextEditingValue(text: '1,00');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '100');
  });

  test('allows to begin entering decimals', () async {
    var oldValue = TextEditingValue(text: '1');
    var newValue = TextEditingValue(text: '1.');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1.');
  });

  test('allows to begin entering decimals using comma', () async {
    var oldValue = TextEditingValue(text: '1');
    var newValue = TextEditingValue(text: '1,');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1.');
  });

  test('allows to begin entering decimals after thousands using comma',
      () async {
    var oldValue = TextEditingValue(text: '1,000');
    var newValue = TextEditingValue(text: '1,000,');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1,000.');
  });

  test('can begin entering decimals', () async {
    var oldValue = TextEditingValue(
        text: '1', selection: TextSelection(baseOffset: 1, extentOffset: 1));
    var newValue = TextEditingValue(
        text: '1.', selection: TextSelection(baseOffset: 2, extentOffset: 2));
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1.');
  });

  test('can enter decimals with leading zeros', () async {
    var oldValue = TextEditingValue(
        text: '1.', selection: TextSelection(baseOffset: 2, extentOffset: 2));
    var newValue = TextEditingValue(
        text: '1.0', selection: TextSelection(baseOffset: 3, extentOffset: 3));
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1.0');

    oldValue = TextEditingValue(
        text: '1.0', selection: TextSelection(baseOffset: 3, extentOffset: 3));
    newValue = TextEditingValue(
        text: '1.05', selection: TextSelection(baseOffset: 4, extentOffset: 4));
    result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1.05');
  });

  test('if adding digits in front, selection remains there', () async {
    var oldValue = TextEditingValue(
        text: '1', selection: TextSelection(baseOffset: 1, extentOffset: 1));
    var newValue = TextEditingValue(
        text: '.1', selection: TextSelection(baseOffset: 2, extentOffset: 2));
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '.1');
  });

  test('keeps offset at end if adding onto end', () async {
    var oldValue = TextEditingValue(
        text: '100', selection: TextSelection(baseOffset: 3, extentOffset: 3));
    var newValue = TextEditingValue(
        text: '1000', selection: TextSelection(baseOffset: 4, extentOffset: 4));
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1,000');
    expect(result.selection.baseOffset, 5);
    expect(result.selection.extentOffset, 5);
  });

  // this case allows deletion to not get into a bad loop
  test('keeps offset unless text changes', () async {
    var oldValue = TextEditingValue(
        text: '1000', selection: TextSelection(baseOffset: 4, extentOffset: 4));
    var newValue = TextEditingValue(
        text: '1000', selection: TextSelection(baseOffset: 3, extentOffset: 4));
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.selection.baseOffset, 3);
    expect(result.selection.extentOffset, 4);
  });

  test('can convert dififerent formats back to double', () async {
    expect(CurrencyInputFormatter.toDouble('1,000'), 1000);
    expect(CurrencyInputFormatter.toDouble('1 000 000'), 1000000);
    expect(CurrencyInputFormatter.toDouble('1,000,000'), 1000000);
    expect(CurrencyInputFormatter.toDouble('100.150'), 100.15);
  });
}
