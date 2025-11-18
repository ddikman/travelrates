import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/data/countries_data.dart';
import 'package:travelconverter/data/currency_data.dart';

void main() {
  test('all currencies except shortlist are connected to at least one country',
      () {
    // Get all currency codes
    final allCurrencyCodes =
        CurrencyData.currencies.map((currency) => currency.code).toSet();

    // Get all currency codes used by countries
    final countryCurrencyCodes = CountryData.countries
        .map((country) => country.currencyCode)
        .where((code) => code.isNotEmpty) // Filter out empty currency codes
        .toSet();

    // Find currencies that are not in the excluded list and not connected to any country
    final unconnectedCurrencies = allCurrencyCodes
        .where((currencyCode) =>
            currencyCode.toUpperCase() != 'BTC' &&
            !countryCurrencyCodes.contains(currencyCode))
        .toList();

    expect(unconnectedCurrencies, isEmpty,
        reason:
            'The following currencies are not connected to any country: ${unconnectedCurrencies.join(", ")}');
  });
}
