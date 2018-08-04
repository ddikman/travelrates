import 'package:backpacking_currency_converter/model/currency.dart';

/// The user currency conversions
class ConversionModel {
  final double currentAmount;

  final Currency currentCurrency;

  final List<String> _currencies;

  ConversionModel(
      {this.currentAmount, this.currentCurrency, List<String> currencies})
      : this._currencies = currencies;

  List<String> get currencies {
    if (_currencies == null) {
      throw new StateError(
          "Cannot call .currencies before app state has been loaded");
    }

    return _currencies;
  }

  double getAmountInCurrency(Currency currency) {
    if (currency.code == currentCurrency.code) {
      return currentAmount;
    }

    return getAmountInBaseCurrency() * currency.rate;
  }

  double getAmountInBaseCurrency() {
    return currentAmount / currentCurrency.rate;
  }

  ConversionModel withCurrencies(List<String> currencies) {
    return new ConversionModel(
        currencies: currencies,
        currentAmount: this.currentAmount,
        currentCurrency: this.currentCurrency);
  }

  ConversionModel withAmount({double amount, Currency currency}) {
    return new ConversionModel(
        currentAmount: amount,
        currentCurrency: currency,
        currencies: this.currencies);
  }
}
