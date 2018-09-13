const indent = require('./indent.js')

module.exports = function (sourceLocale, translations) {
  return `// THIS IS A GENERATED FILE
  // Please don't edit this file. Instead regenerate it with the tools/generate_localizations.js tool

  class CountryLocalizations {

    static final _allLocales = {
${indent(translations, 6)}
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
}
