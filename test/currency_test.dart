import 'package:test/test.dart';

import 'mocks/mock_currency.dart';

void main() {
  test('currency name is formatted with name and symbol', () {
    expect(MockCurrency.euro.toString(), 'Euro, €');
  });
}
