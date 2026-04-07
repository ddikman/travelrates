// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

String indent(String text, int spaces) {
  final prefix = ' ' * spaces;
  return text.replaceAllMapped(RegExp(r'^(?=.)', multiLine: true), (m) => prefix);
}

String buildCountryLocalizationsFile(String sourceLocale, String translations) {
  return '''// THIS IS A GENERATED FILE
  // Please don't edit this file. Instead regenerate it with the tools/generate_localizations.dart tool

  class CountryLocalizations {

    static final _allLocales = {
${indent(translations, 6)}
    };

    final String locale;

    final Map<String, String> _translations;

    CountryLocalizations._internal(this.locale, this._translations);

    factory CountryLocalizations(String locale) {
      assert(_allLocales.containsKey(locale) || locale == '$sourceLocale');
      if (locale == '$sourceLocale') {
        return CountryLocalizations._internal(locale, {});
      } else {
        return CountryLocalizations._internal(locale, _allLocales[locale]!);
      }
    }

    String getLocalized(String countryName) {
      // Skip localization if it's already in the default locale
      if (locale == '$sourceLocale') return countryName;

      final localized = _translations[countryName];
      if (localized == null) {
        throw StateError("Missing localization for country '\$countryName'.");
      }

      return localized;
    }

  }''';
}

String buildCurrencyLocalizationsFile(String translations) {
  return '''// THIS IS A GENERATED FILE
  // Please don't edit this file. Instead regenerate it with the tools/generate_localizations.dart tool

  class CurrencyLocalizations {

    static final _locales = {
${indent(translations, 6)}
    };

    final String locale;

    final Map<String, String> _currencies;

    CurrencyLocalizations._internal(this.locale, this._currencies);

    factory CurrencyLocalizations(String locale) {
      assert(_locales.containsKey(locale));
      return CurrencyLocalizations._internal(locale, _locales[locale]!);
    }

    String getLocalized(String currencyCode) {
      final localized = _currencies[currencyCode];
      if (localized == null) {
        throw StateError("Missing name for currency '\$currencyCode'.");
      }

      return localized;
    }

  }''';
}

void writeDartFile(String path, String contents) {
  print('writing and formatting dart file..');
  File(path).writeAsStringSync(contents);
  Process.runSync('fvm', ['dart', 'format', path]);
  print('written new localizations to: $path');
}

void main() {
  const sourceLocale = 'en';
  const supportedLocales = ['en', 'ja', 'sv'];

  print('building localization for supported locales: $supportedLocales');
  print("basing all locales on the default locale '$sourceLocale'");

  // Generate country localizations
  final countries = jsonDecode(
    File('assets/l10n/countries.json').readAsStringSync(),
  ) as List<dynamic>;

  final countryLocales = supportedLocales.where((l) => l != sourceLocale);
  final countryTranslations = countryLocales.map((locale) {
    final localizedNames = countries.map((c) {
      final translations = c as Map<String, dynamic>;
      return '"${translations[sourceLocale]}": "${translations[locale]}"';
    }).join(',\n');

    return '"$locale": {\n${indent(localizedNames, 2)}\n    }';
  }).join(',\n');

  writeDartFile(
    'lib/l10n/country_localizations.dart',
    buildCountryLocalizationsFile(sourceLocale, countryTranslations),
  );

  // Generate currency localizations
  final currencies = jsonDecode(
    File('assets/l10n/currencies.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  final currencyTranslations = supportedLocales.map((locale) {
    final codes = currencies.keys.map((code) {
      final translations = currencies[code] as Map<String, dynamic>;
      return '"$code": "${translations[locale]}"';
    });
    final codesStr = indent(codes.join(',\n'), 2);
    return '"$locale": {\n      $codesStr\n    }';
  }).join(',\n');

  writeDartFile(
    'lib/l10n/currency_localizations.dart',
    buildCurrencyLocalizationsFile(currencyTranslations),
  );
}
