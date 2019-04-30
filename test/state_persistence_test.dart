import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'mocks/mock_bundle.dart';
import 'mocks/mock_local_storage.dart';

void main() {
  var assets = new TestAssetBundle();

  test('can load default state', () async {
    final localStorage = new MockLocalStorage();
    final statePersistence = new StatePersistence(localStorage: localStorage);

    final appState = await statePersistence.load(assets);

    expect(appState.conversion.currentAmount, 1.0);
    expect(appState.conversion.currentCurrency.code, "EUR");
  });

  test('can previous state', () async {
    final localStorage = new MockLocalStorage();
    localStorage.setFile("state.json", '{"currentAmount":5.0,"currentCurrency":"USD","currencies":["USD","EUR"]}');

    final statePersistence = new StatePersistence(localStorage: localStorage);

    final appState = await statePersistence.load(assets);

    expect(appState.conversion.currentAmount, 5.0);
    expect(appState.conversion.currentCurrency.code, "USD");
    expect(appState.conversion.currencies, [ "USD", "EUR" ]);
  });
}