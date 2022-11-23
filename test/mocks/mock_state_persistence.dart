import 'package:travelconverter/app_state.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'mock_currency_repository.dart';
import 'mock_local_storage.dart';

class MockStatePersistence implements StatePersistence {
  AppState _appState = AppState.initial(
      countries: [], availableCurrencies: mockCurrencyRepository());

  @override
  Future<AppState> load(AssetBundle assets) {
    return Future.value(_appState);
  }

  @override
  get localStorage => MockLocalStorage();

  @override
  Future<Null> store(AppState appState) {
    _appState = appState;
    return Future.value(null);
  }
}
