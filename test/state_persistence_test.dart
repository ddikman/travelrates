import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'mocks/mock_bundle.dart';
import 'mocks/mock_local_storage.dart';

void main() {
  var assets = new TestAssetBundle();
  assets.set("assets/data/currencies.json", '{"USD":{"symbol":"\$","name":"US Dollar","symbol_native":"\$","decimal_digits":2,"rounding":0,"code":"USD","name_plural":"US dollars","icon":"US"},"EUR":{"symbol":"€","name":"Euro","symbol_native":"€","decimal_digits":2,"rounding":0,"code":"EUR","name_plural":"euros","icon":"EU"}}');
  assets.set('assets/data/rates.json', '{ "rates": { "USD": 212.0, "EUR": 1 } }');
  assets.set('assets/data/countries.json', '[{"name":"United States","code":"US","currency":"USD"},{"name":"Germany","code":"DE","currency":"EUR"}]');

  test('can load default state', () async {
    final localStorage = new MockLocalStorage();
    final statePersistence = new StatePersistence(localStorage: localStorage);
    
    final ratesLoader = new RatesLoader(localStorage: localStorage);
    final appState = await statePersistence.load(ratesLoader, assets);

    expect(appState.conversion.currentAmount, 1.0);
    expect(appState.conversion.currentCurrency.code, "EUR");
  });

  test('can previous state', () async {
    final localStorage = new MockLocalStorage();
    localStorage.setFile("state.json", '{"currentAmount":5.0,"currentCurrency":"USD","currencies":["USD","EUR"]}');

    final statePersistence = new StatePersistence(localStorage: localStorage);

    final ratesLoader = new RatesLoader(localStorage: localStorage);
    final appState = await statePersistence.load(ratesLoader, assets);

    expect(appState.conversion.currentAmount, 5.0);
    expect(appState.conversion.currentCurrency.code, "USD");
    expect(appState.conversion.currencies, [ "USD", "EUR" ]);
  });
}