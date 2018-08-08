import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/services/currency_repository.dart';

/// helper ot mock a currency repository
CurrencyRepository mockCurrencyRepository() {
  final currencies = <Currency>[
    new Currency(
        name: "Euro", code: "EUR", icon: "EUR", symbol: '€', rate: 1.0),
    new Currency(
        name: "Sterling silver",
        code: "GBP",
        icon: "GBP",
        symbol: "£",
        rate: 0.88),
    new Currency(
        name: "United States Dollar",
        code: "USD",
        symbol: '\$',
        icon: "USD",
        rate: 1.169),
  ];

  return new CurrencyRepository(currencies: currencies, baseRate: "EUR");
}
