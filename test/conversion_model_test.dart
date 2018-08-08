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

  test('convertion is done based on the difference between current and exchanged currency rates',
      () {

    final model = new ConversionModel(
        currentAmount: 1.0,
        currentCurrency: MockCurrency.dollar,
        currencies: <String>[]);

    // the euro base rate is 1.0 since it's the base rate for all currencies
    // that means that the dollar rate is only relative to the euro as below
    final expectedEuro = 1.0 / MockCurrency.dollar.rate;
    expect(model.getAmountInCurrency(MockCurrency.euro), expectedEuro);

    // for other currencies, we need to first convert it to euro (as above)
    // and then following convert those euro down to the new currency rate
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
