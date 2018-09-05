import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moneyconverter/asset_paths.dart';

class CountryNameLocalizations {

  final Map<String, String> _countryNames;

  CountryNameLocalizations(this._countryNames);

  static Future<CountryNameLocalizations> loadFrom(String locale) async {
    // TODO: find a way to not use the rootBundle here to avoid static accessors
    final json = await rootBundle.loadString(AssetPaths.localizedCountriesJson);
    final localized = load(json, locale);
    return new CountryNameLocalizations(localized);
  }

  static Map<String, String> load(String json, String locale) {

    final countryNames = new Map<String, String>();

    final Map countriesList = JsonDecoder().convert(json);
    countriesList.forEach((countryName, translations) {

      // default to the key
      if (locale == 'en') {
        countryName[countryName] == countryName;
        return;
      }

       if (!translations.containsKey(locale)) {
         throw new StateError("Missing localization for country '$countryName' and locale '$locale'.");
       }
       countryNames[countryName] = translations[locale];
    });

    return countryNames;
  }


  String getLocalized(String countryName) {
    if (_countryNames.containsKey(countryName)) {
      return _countryNames[countryName];
    }

    print("Missing localization for country '$countryName'.");
    return countryName;
  }
}