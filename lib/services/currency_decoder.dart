import 'dart:async';
import 'dart:convert';

import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/services/currency_repository.dart';

class CurrencyDecoder {
  static const String _baseRateCurrencyCode = 'EUR';

  Future<CurrencyRepository> decode(
      String currenciesJson, String ratesJson) async {
    assert(currenciesJson != null);
    assert(ratesJson != null);

    final rates = _decodeRates(ratesJson);
    final currencies = _decodeCurrencies(currenciesJson, rates);

    return CurrencyRepository(
        currencies: currencies, baseRate: _baseRateCurrencyCode);
  }

  List<Currency> _decodeCurrencies(String json, Map rates) {
    final Map currencies = new JsonDecoder().convert(json);
    return currencies.values
        .map((currency) => _decodeCurrency(currency, rates))
        .toList();
  }

  Map _decodeRates(String json) {
    assert(json != null && json.isNotEmpty);
    final Map ratesDecoded = new JsonDecoder().convert(json);
    if (!ratesDecoded.containsKey('rates')) {
      throw new ArgumentError(
          "Rates json does not contain a child element named 'rates'.");
    }

    return ratesDecoded['rates'];
  }

  Currency _decodeCurrency(Map currency, Map rates) {
    final code = currency['code'];

    // the base rate is stored as integer in json so make sure it's a
    // double to avoid casting issue
    var rate = code == _baseRateCurrencyCode ? 1.0 : rates[code];

    return Currency(
        symbol: currency['symbol_native'],
        name: currency['name'],
        code: code,
        icon: currency['icon'],
        rate: rate);
  }
}
