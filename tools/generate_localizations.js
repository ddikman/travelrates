const fs = require('fs')
const exec = require('child_process').execSync

const countries = JSON.parse(fs.readFileSync('./assets/l10n/countries.json'))
const currencies = JSON.parse(fs.readFileSync('./assets/l10n/currencies.json'))

// all locales are based/mapped on the english locale
const sourceLocale = 'en'

const supportedLocales = Object.keys(countries[0])
console.log(`building localization for supported locales: ${supportedLocales}`)
console.log(`basing all locales on the default locale '${sourceLocale}'`)



var allTranslations = supportedLocales.filter((locale) => locale != sourceLocale).map(function(locale) {
  var translations = countries.map(function (countryTranslations) {
    return `"${countryTranslations[sourceLocale]}": "${countryTranslations[locale]}"`
  })
  translations = indent(translations.join(",\n\r"), 4)
  return `"${locale}": {
${indent(translations, 4)}
  }`
})

allTranslations = indent(allTranslations.join(",\r\n"))

var countriesFile = `// THIS IS A GENERATED FILE
// Please don't edit this file. Instead regenerate it with the tools/generate_localizations.js tool

class CountryLocalizations {

  static final _allLocales = {
    ${allTranslations}
  };

  final String locale;

  final Map<String, String> _translations;

  CountryLocalizations._internal(this.locale, this._translations);

  factory CountryLocalizations(String locale) {
    assert(_allLocales.containsKey(locale) || locale == '${sourceLocale}');
    if (locale == '${sourceLocale}') {
      return new CountryLocalizations._internal(locale, null);
    } else {
      return new CountryLocalizations._internal(locale, _allLocales[locale]);
    }
  }

  String getLocalized(String countryName) {
    // Skip localization if it's already in the default locale
    if (locale == '${sourceLocale}') return countryName;

    if (!_translations.containsKey(countryName)) {
      print("Missing localization for country '$countryName'.");
      return countryName;
    }

    return _translations[countryName];
  }

}`

var path = './lib/l10n/country_localizations.dart'
fs.writeFileSync(path, countriesFile)

console.log('formatting file..')
exec(`flutter format ${path}`)

console.log(`written new country localizations to: ${path}`)


allTranslations = supportedLocales.map(function(locale) {
  var currencyCodes = Object.keys(currencies).map(function(code) {
    return `"${code}": "${currencies[code][locale]}"`
  })
  currencyCode = indent(currencyCodes.join(',\r\n'), 2)
  return `"${locale}": {
    ${currencyCodes}
  }`
})
allTranslations = indent(allTranslations.join(',\r\n'), 4)

var currenciesFile = `// THIS IS A GENERATED FILE
// Please don't edit this file. Instead regenerate it with the tools/generate_localizations.js tool

class CurrencyLocalizations {

  static final _locales = {
${allTranslations}
  };

  final String locale;

  final Map<String, String> _currencies;

  CurrencyLocalizations._internal(this.locale, this._currencies);

  factory CurrencyLocalizations(String locale) {
    assert(_locales.containsKey(locale));
    return new CurrencyLocalizations._internal(locale, _locales[locale]);
  }

  String getLocalized(String currencyCode) {
    if (!_currencies.containsKey(currencyCode)) {
      throw StateError("Missing name for currency '$currencyCode'.");
    }

    return _currencies[currencyCode];
  }

}`

var path = './lib/l10n/currency_localizations.dart'
fs.writeFileSync(path, currenciesFile)

console.log('formatting file..')
exec(`flutter format ${path}`)

console.log(`written new country localizations to: ${path}`)


function indent(text, indentation) {
  indentation = ' '.repeat(indentation)
  return text.replace(/^(?=.)/gm, indentation)
}
