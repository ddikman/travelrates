import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/convert/currency_input_formatter.dart';


void main() {

  var currencyInputFormatter = new CurrencyInputFormatter();

  test('can add single digits', () async {
    var oldValue = new TextEditingValue(text: '');
    var newValue = new TextEditingValue(text: '1');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1');
  });

  test('formats thousands with seperators', () async {
    var oldValue = new TextEditingValue(text: '100');
    var newValue = new TextEditingValue(text: '1000');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1,000');
  });

  test('rounds off to closest thousand', () async {
    var oldValue = new TextEditingValue(text: '1000');
    var newValue = new TextEditingValue(text: '10001');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '10,000');
  });

  test('ignores leading zeros', () async {
    var oldValue = new TextEditingValue(text: '0');
    var newValue = new TextEditingValue(text: '01');
    var result = currencyInputFormatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '1');
  });
}
