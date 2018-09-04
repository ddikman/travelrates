
import 'package:travelconverter/helpers/sorting.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/model/currency.dart';

class CurrencyFilter
{
  final List<Currency> currencies;
  final List<Country> countries;

  CurrencyFilter(this.currencies, this.countries);

  List<Currency> getFiltered(String filterText) {
    filterText = filterText.toLowerCase();

    // no filter => all currencies
    if (filterText.isEmpty) {
      return _sorted(List.from(this.currencies));
    }

    final matchingCountries = List<Country>.from(countries);
    matchingCountries.retainWhere(
            (country) => country.name.toLowerCase().contains(filterText));

    final filteredCurrencies = List<Currency>.from(this.currencies);
    filteredCurrencies.retainWhere((currency) {
      return currency.name.toLowerCase().contains(filterText) ||
          currency.code.toLowerCase().contains(filterText) ||
          matchingCountries
              .any((country) => country.currencyCode == currency.code);
    });

    return _sorted(filteredCurrencies);
  }

  List<Currency> _sorted(List<Currency> currencies) {
    return alphabeticallySorted<Currency>(currencies, (currency) => currency.name);
  }
}