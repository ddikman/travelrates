import 'package:travelconverter/helpers/string_compare.dart';
import 'package:travelconverter/l10n/localized_data.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/model/currency.dart';

class CurrencyFilter {
  final List<Country> countries;
  final LocalizedData _localizations;

  CurrencyFilter(this.countries, this._localizations);

  List<Currency> getFiltered(List<Currency> currencies, String filterText) {
    filterText = filterText.toLowerCase();

    // no filter => all currencies
    if (filterText.isEmpty) {
      return List.from(currencies);
    }

    final matchingCountries = List<Country>.from(countries);
    matchingCountries
        .retainWhere((country) => _countryMatchesFilter(country, filterText));

    final filteredCurrencies = List<Currency>.from(currencies);
    filteredCurrencies.retainWhere((currency) =>
        _currencyMatchesFilter(currency, filterText) ||
        _currencyMatchesCountry(currency, matchingCountries));

    return filteredCurrencies;
  }

  bool _countryMatchesFilter(Country country, String filterText) {
    return containsIgnoreCase(country.name, filterText) ||
        _localizedNameContains(country.name, filterText);
  }

  bool _localizedNameContains(String countryName, String filterText) {
    final localizedName = _localizations.countries.getLocalized(countryName);
    return containsIgnoreCase(localizedName, filterText);
  }

  bool _currencyMatchesFilter(Currency currency, String filterText) {
    return containsIgnoreCase(currency.name, filterText) ||
        containsIgnoreCase(currency.code, filterText) ||
        _localizedCurrencyContains(currency.code, filterText);
  }

  bool _localizedCurrencyContains(String currencyCode, String filterText) {
    final localizedCurrency =
        _localizations.currencies.getLocalized(currencyCode);
    return containsIgnoreCase(localizedCurrency, filterText);
  }

  bool _currencyMatchesCountry(
      Currency currency, List<Country> matchingCountries) {
    return matchingCountries
        .any((country) => country.currencyCode == currency.code);
  }
}
