import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/l10n/country_localizations.dart';
import 'package:travelconverter/l10n/currency_localizations.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/use_cases/edit_currencies/services/currency_filter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_currency.dart';

void main() {
  final countryLocalizations = new CountryLocalizations('sv');
  final currencyLocalizations = new CurrencyLocalizations('sv');
  final localizations =
      new AppLocalizations(countryLocalizations, currencyLocalizations);

  final countries = [
    new Country("United States", "US", "USD"),
    new Country("United Kingdom", "GB", "GBP"),
    new Country("Germany", "DE", "EUR")
  ];

  var dollar = MockCurrency.dollar;
  var pound = MockCurrency.pound;
  var euro = MockCurrency.euro;
  var currencies = [dollar, pound, euro];

  // The filter shouldn't be localizing things, they should already be localized.
  // The filter should specify the rules, not the data to filter.
  final filter = new CurrencyFilter(countries, localizations);

  test(
      "When english country name partially matches returns that country`s currency",
      () {
    expect(filter.getFiltered(currencies, "States"), contains(dollar));
  });

  test(
      "When localized country name partially matches returns that country`s currency",
      () {
    expect(filter.getFiltered(currencies, "Ame"), contains(dollar));
  });

  test("When currency code matches partially, returns the given currency", () {
    expect(filter.getFiltered(currencies, 'Us'), contains(dollar));
  });

  test("When currency name matches partially, returns the given currency", () {
    expect(filter.getFiltered(currencies, 'eur'), contains(euro));
  });

  test("When localized currency name matches partially, returns the currency",
      () {
    expect(filter.getFiltered(currencies, "pun"), contains(pound));
  });

  test("When not supplying filter text, returns all currencies", () {
    expect(filter.getFiltered(currencies, ""), currencies);
  });
}
