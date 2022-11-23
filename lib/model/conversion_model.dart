import 'package:travelconverter/model/currency.dart';

/// The user currency conversions
class ConversionModel {
  final double currentAmount;

  final Currency currentCurrency;

  final List<String> _currencies;

  ConversionModel(
      {required this.currentAmount,
      required this.currentCurrency,
      required List<String> currencies})
      : this._currencies = currencies;

  List<String> get currencies => _currencies;

  double getAmountInCurrency(Currency currency) {
    if (currency.code == currentCurrency.code) {
      return currentAmount;
    }

    return _getAmountInBaseCurrency() * currency.rate;
  }

  double _getAmountInBaseCurrency() {
    return currentAmount / currentCurrency.rate;
  }

  ConversionModel withCurrencies(List<String> currencies) {
    return new ConversionModel(
        currencies: currencies,
        currentAmount: this.currentAmount,
        currentCurrency: this.currentCurrency);
  }

  ConversionModel withAmount(
      {required double amount, required Currency currency}) {
    return new ConversionModel(
        currentAmount: amount,
        currentCurrency: currency,
        currencies: this.currencies);
  }
}
