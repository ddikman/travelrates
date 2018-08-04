import 'dart:async';
import 'dart:convert';

import 'package:backpacking_currency_converter/helpers/string_compare.dart';
import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/model/currency_rate.dart';
import 'package:backpacking_currency_converter/services/currency_repository.dart';

class CurrencyDecoder {
  static const String _baseRateCurrencyCode = 'EUR';

  Future<CurrencyRepository> decode(
      String currenciesJson, String ratesJson) async {
    assert(currenciesJson != null);
    assert(ratesJson != null);

    final rates = decodeRates(ratesJson);
    final currencies = _decodeCurrencies(currenciesJson, rates);

    return CurrencyRepository(
        currencies: currencies, baseRate: _baseRateCurrencyCode);
  }

  List<Currency> _decodeCurrencies(String json, List<CurrencyRate> rates) {
    final Map currencies = new JsonDecoder().convert(json);
    return currencies.values
        .where(_notDiscontinued)
        .map((currency) => _decodeCurrency(currency, rates))
        .toList();
  }

  bool _notDiscontinued(dynamic currency) {
    return currency['discontinued'] != true;
  }

  List<CurrencyRate> decodeRates(String json) {
    assert(json != null && json.isNotEmpty);
    final Map ratesDecoded = new JsonDecoder().convert(json);
    if (!ratesDecoded.containsKey('rates')) {
      throw new ArgumentError(
          "Rates json does not contain a child element named 'rates'.");
    }

    Map<String, dynamic> ratesMap = ratesDecoded['rates'];
    return ratesMap.entries.map((e) => _mapRate(e.key, e.value)).toList();
  }

  CurrencyRate _mapRate(String code, dynamic rate) {
    // the json will contain a base rate with an integer 1 instead of a double
      if (rate is int) {
        return new CurrencyRate(code, 1.0);
      } else if (rate is double) {
        return new CurrencyRate(code, rate);
      } else {
        throw new Exception("Unexpected rate type for code '$code': ${rate.runtimeType}");
      }
  }

  Currency _decodeCurrency(Map currency, List<CurrencyRate> rates) {
    final code = currency['code'];
    final rate = rates.singleWhere((rate) => isEqualIgnoreCase(rate.currencyCode, code),
        orElse: () => throw new Exception("Missing rate for currency $code amongt ${rates.length} rates"));

    return Currency(
        symbol: currency['symbol_native'],
        name: currency['name'],
        code: code,
        icon: currency['icon'],
        rate: rate.rate);
  }
}
