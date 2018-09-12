
import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:moneyconverter/l10n/country_localizations.dart';
import 'package:moneyconverter/l10n/currency_localizations.dart';
import 'package:moneyconverter/l10n/messages_all.dart';

class AppLocalizations {

  final CountryLocalizations _countries;

  final CurrencyLocalizations _currencies;

  AppLocalizations(this._countries, this._currencies);

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    print("Initializing localisations for '$localeName'.");

    final countries = new CountryLocalizations(locale.languageCode);
    final currencies = new CurrencyLocalizations(locale.languageCode);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations(countries, currencies);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  CountryLocalizations get countries => _countries;

  CurrencyLocalizations get currencies => _currencies;
}