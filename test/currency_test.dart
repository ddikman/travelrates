import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:test/test.dart';

void main() {
  test('currency name is formatted with name and symbol', () {
    final currency = new Currency(name: 'Euro', symbol: '€', code: 'EUR', icon: 'EUR', rate: 1.0);
    expect(currency.toString(), 'Euro, €');
  });
}
