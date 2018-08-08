import 'package:backpacking_currency_converter/app_state.dart';
import 'package:backpacking_currency_converter/model/country.dart';
import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/services/currency_repository.dart';

class MockState {

  static AppState buildDefault() {
    final countries = <Country>[
      new Country("England", "EN", "GBP"),
      new Country("Germany", "DE", "EUR"),
      new Country("United States", "US", "USD")
    ];

    final currencies = <Currency>[
      new Currency(
        name: "Euro",
        code: "EUR",
        icon: "EUR",
        symbol: '€',
        rate: 1.0
      ),
      new Currency(
          name: "Sterling silver",
          code: "GBP",
          icon: "GBP",
          symbol: "£",
          rate: 0.88
      ),
      new Currency(
          name: "United States Dollar",
          code: "",
          symbol: '\$',
          icon: "USD",
          rate: 1.169
      ),
    ];

    final currencyRepo = new CurrencyRepository(currencies: currencies, baseRate: "EUR");

    return AppState.initial(countries: countries, availableCurrencies: currencyRepo);
  }

}