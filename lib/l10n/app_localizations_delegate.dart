import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:travelconverter/l10n/app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  const AppLocalizationsDelegate();

  static List<Locale> get supportedLocales => [
    const Locale('en', 'GB'),
    const Locale('ja', 'JP'),
    const Locale('sv', 'SE')
  ];

  @override
  bool isSupported(Locale locale) {
    if (supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      return true;
    }
    print("Missing support for requested locale '${locale.countryCode}|${locale.languageCode}'.");
    return false;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }
}