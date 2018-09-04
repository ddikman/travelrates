import 'package:moneyconverter/model/currency.dart';
import 'package:moneyconverter/services/currency_repository.dart';

import 'mock_currency.dart';

/// helper ot mock a currency repository
CurrencyRepository mockCurrencyRepository() {
  final currencies = <Currency>[
    MockCurrency.dollar,
    MockCurrency.euro,
    MockCurrency.pound
  ];

  return new CurrencyRepository(currencies: currencies, baseRate: "EUR");
}
