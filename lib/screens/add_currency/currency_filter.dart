
import 'package:moneyconverter/helpers/sorting.dart';
import 'package:moneyconverter/l10n/app_localizations.dart';
import 'package:moneyconverter/model/country.dart';
import 'package:moneyconverter/model/currency.dart';

class CurrencyFilter
{
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
    matchingCountries.retainWhere(
            (country) => country.name.toLowerCase().contains(filterText) ||
              _localizations.countries.getLocalized(country.name).toLowerCase().contains(filterText));

    final filteredCurrencies = List<Currency>.from(this.currencies);
    filteredCurrencies.retainWhere((currency) {
      return currency.name.toLowerCase().contains(filterText) ||
          currency.code.toLowerCase().contains(filterText) ||
          _localizations.currencies.getLocalized(currency.code).toLowerCase().contains(filterText) ||
          matchingCountries
              .any((country) => country.currencyCode == currency.code);
    });

    return _sorted(filteredCurrencies);
  }

  List<Currency> _sorted(List<Currency> currencies) {
    return alphabeticallySorted<Currency>(currencies, (currency) => currency.name);
  }
}