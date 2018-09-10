import 'package:moneyconverter/helpers/sorting.dart';
import 'package:moneyconverter/helpers/string_compare.dart';
import 'package:moneyconverter/l10n/app_localizations.dart';
import 'package:moneyconverter/model/country.dart';
import 'package:moneyconverter/model/currency.dart';

class CurrencyFilter {
  final List<Currency> currencies;
  final List<Country> countries;
  final AppLocalizations _localizations;

  CurrencyFilter(this.currencies, this.countries, this._localizations);

  List<Currency> getFiltered(String filterText) {
    filterText = filterText.toLowerCase();

    // no filter => all currencies
    if (filterText.isEmpty) {
      return _sorted(List.from(this.currencies));
    }

    final matchingCountries = List<Country>.from(countries);
    matchingCountries
        .retainWhere((country) => _countryMatchesFilter(country, filterText));

    final filteredCurrencies = List<Currency>.from(this.currencies);
    filteredCurrencies.retainWhere((currency) =>
        _currencyMatchesFilter(currency, filterText) ||
        _currencyMatchesCountry(currency, matchingCountries));

    return _sorted(filteredCurrencies);
  }

  List<Currency> _sorted(List<Currency> currencies) {
    return alphabeticallySorted<Currency>(
        currencies, (currency) => currency.name);
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
