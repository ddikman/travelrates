import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/country.dart';

import 'mock_currency_repository.dart';

AppState mockAppState() {
  final countries = <Country>[
    new Country("England", "EN", "GBP"),
    new Country("Germany", "DE", "EUR"),
    new Country("United States", "US", "USD")
  ];

  return AppState.initial(countries: countries, availableCurrencies: mockCurrencyRepository());
}