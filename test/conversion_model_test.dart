import 'package:backpacking_currency_converter/model/conversion_model.dart';
import 'package:test/test.dart';

import 'mocks/mock_currency.dart';

void main() {
  test('throws if getting currencies before loaded', () {
    final uninitiatedModel = new ConversionModel(
        currentAmount: 1.0,
        currentCurrency: MockCurrency.euro,
        currencies: null);

    expect(
        () => uninitiatedModel.currencies, throwsA(isInstanceOf<StateError>()));
  });

  test('when getting conversion of current currency returns same value', () {
    const currentAmount = 1.0;
    final model = new ConversionModel(
        currentAmount: currentAmount,
        currentCurrency: MockCurrency.euro,
        currencies: <String>[]);

    expect(model.getAmountInCurrency(MockCurrency.euro), currentAmount);
  });

  test('when changing currency, conversion between should work as expected',
      () {
    // example, we've currently set the value as 1 USD
    // then the value in EUR should be 1 USD split by the rate since
    // the base rate is EUR. If we convert to GBP however, it's first
    // split by USD to get EUR then multiplied to GBP rate
    final model = new ConversionModel(
        currentAmount: 1.0,
        currentCurrency: MockCurrency.dollar,
        currencies: <String>[]);

    final expectedEuro = 1.0 / MockCurrency.dollar.rate;
    expect(model.getAmountInCurrency(MockCurrency.euro), expectedEuro);

    final expectedPound =
        (1.0 / MockCurrency.dollar.rate) * MockCurrency.pound.rate;
    expect(model.getAmountInCurrency(MockCurrency.pound), expectedPound);
  });

  test('can clone model with new currencies and amounts', () {
    var model = new ConversionModel(
        currencies: <String>[],
        currentCurrency: MockCurrency.euro,
        currentAmount: 2.0);

    model = model.withAmount(amount: 1.0, currency: MockCurrency.dollar);
    expect(model.currentAmount, 1.0);
    expect(model.currentCurrency.code, "USD");

    final newCurrencies = <String>["USD", "EUR"];
    model = model.withCurrencies(newCurrencies);
    expect(model.currencies, newCurrencies);
  });
}
