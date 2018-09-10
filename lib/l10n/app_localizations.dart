
import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:moneyconverter/l10n/country_name_localizations.dart';
import 'package:moneyconverter/l10n/currency_localizations.dart';
import 'package:moneyconverter/l10n/messages_all.dart';

class AppLocalizations {

  final CountryNameLocalizations _countries;

  final CurrencyLocalizations _currencies;

  AppLocalizations(this._countries, this._currencies);

  static Future<AppLocalizations> load(Locale locale, BuildContext context) async {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    print("Initializing localisations for '$localeName'.");

    final countries = await CountryNameLocalizations.loadFrom(context, locale.languageCode);
    final currencies = await CurrencyLocalizations.loadFrom(context, locale.languageCode);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations(countries, currencies);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  CountryNameLocalizations get countries => _countries;

  CurrencyLocalizations get currencies => _currencies;
}