import 'package:backpacking_currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';


class CurrencyRepository {
  // TODO: encapsulate?
  final List<Currency> currencies;
  final String baseRate;

  CurrencyRepository({this.currencies, this.baseRate});

  Currency getBaseRateCurrency() => getCurrencyByCode(baseRate);

  Currency getCurrencyByCode(String code) {
    code = code.toUpperCase();
    var matches = currencies.where((currency) => currency.code.toUpperCase() == code);
    if (matches.isEmpty) {
      print("Found no currency with code [$code] among ${currencies
          .length} currencies");
      throw StateError("No currency with code $code");
    }
    return matches.first;
  }

  List<Currency> getAllCurrencies() {
    return new List.from(currencies);
  }

  static Future<CurrencyRepository> loadFrom(AssetBundle assets) async {
    final currenciesJson = await assets.loadString('assets/data/currencies.json');

    final currencies = new List<Currency>();
    final Map currenciesMap = JsonDecoder().convert(currenciesJson);

    final ratesJson = await assets.loadString('assets/data/rates.json');
    final Map rates = JsonDecoder().convert(ratesJson)['rates'];

    String baseRateCurrencyCode = 'EUR';
    for (Map currencyMap in currenciesMap.values) {
      final code = currencyMap['code'];

      // the base rate is stored as integer in json so make sure it's a
      // double to avoid casting issue
      var rate = code == baseRateCurrencyCode ? 1.0 : rates[code];

      currencies.add(
          Currency(
              symbol: currencyMap['symbol_native'],
              name: currencyMap['name'],
              code: code,
              rate: rate
          )
      );
    }

    await Future.delayed(Duration(seconds: 2));

    return CurrencyRepository(
      currencies: currencies,
      baseRate: baseRateCurrencyCode
    );
  }
}
