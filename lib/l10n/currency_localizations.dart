import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moneyconverter/asset_paths.dart';

class CurrencyLocalizations {

  final Map<String, String> _currencies;

  CurrencyLocalizations(this._currencies);

  static Future<CurrencyLocalizations> loadFrom(String locale) async {
    // TODO: find a way to not use the rootBundle here to avoid static accessors
    final json = await rootBundle.loadString(AssetPaths.localizedCurrenciesJson);
    final localized = load(json, locale);
    return new CurrencyLocalizations(localized);
  }

  static Map<String, String> load(String json, String locale) {

    final currencyNames = new Map<String, String>();

    final Map currenciesList = JsonDecoder().convert(json);
    currenciesList.forEach((currencyCode, translations) {

      if (!translations.containsKey(locale)) {
        throw new StateError("Missing localization for country '$currencyCode' and locale '$locale'.");
      }
      currencyNames[currencyCode] = translations[locale];
    });

    return currencyNames;
  }


  String getLocalized(String currencyCode) {
    if (!_currencies.containsKey(currencyCode)) {
      throw StateError("Missing name for currency '$currencyCode'.");
    }

    return _currencies[currencyCode];
  }
}