const indent = require('./indent.js')

module.exports = function (translations) {
  return `// THIS IS A GENERATED FILE
  // Please don't edit this file. Instead regenerate it with the tools/generate_localizations.js tool

  class CurrencyLocalizations {

    static final _locales = {
${indent(translations, 6)}
    };

    final String locale;

    final Map<String, String> _currencies;

    CurrencyLocalizations._internal(this.locale, this._currencies);

    factory CurrencyLocalizations(String locale) {
      assert(_locales.containsKey(locale));
      return new CurrencyLocalizations._internal(locale, _locales[locale]!);
    }

    String getLocalized(String currencyCode) {
      final localized = _currencies[currencyCode];
      if (localized == null) {
        throw StateError("Missing name for currency '$currencyCode'.");
      }

      return localized;
    }

  }`
}
