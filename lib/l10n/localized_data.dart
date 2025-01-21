import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/l10n/country_localizations.dart';
import 'package:travelconverter/l10n/currency_localizations.dart';

class LocalizedData {
  final CountryLocalizations countries;
  final CurrencyLocalizations currencies;
  final Locale locale;

  LocalizedData(this.countries, this.currencies, this.locale);

  static LocalizedData withLocale(Locale locale) {
    final String name = locale.countryCode?.isEmpty ?? true
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    print("Initializing localisations for '$localeName'.");

    final countries = CountryLocalizations(locale.languageCode);
    final currencies = CurrencyLocalizations(locale.languageCode);

    return LocalizedData(countries, currencies, locale);
  }
}
