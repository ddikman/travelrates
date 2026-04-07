import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_root.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/services/load_api_configuration.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/preferences.dart';
import 'package:travelconverter/services/rates_api.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:travelconverter/services/shared_preferences.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'package:travelconverter/state_container.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var localStorage = LocalStorage();
  final ratesApiConfig = await loadApiConfiguration();
  final ratesApi = RatesApi(ratesApiConfig);

  // Load cached rates first using RatesLoader
  final ratesLoader =
      RatesLoader(localStorage: localStorage, ratesApi: ratesApi);
  final cachedRatesResponse = await ratesLoader.loadCachedRates();
  final cachedRates =
      cachedRatesResponse.rates.isNotEmpty ? cachedRatesResponse.rates : null;

  final statePersistence = StatePersistence(localStorage: localStorage);
  final state =
      await statePersistence.load(rootBundle, cachedRates: cachedRates);
  final sharedPreferences = await SharedPreferences.initialize(
    prefix: 'travelrates',
  );

  runApp(
    StateContainer(
      state: state,
      statePersistence: statePersistence,
      child: Builder(
        builder: (ctx) => ProviderScope(overrides: [
          appStateProvider.overrideWithValue(StateContainer.of(ctx).appState),
          stateContainerProvider.overrideWithValue(StateContainer.of(ctx)),
          preferencesProvider.overrideWithValue(sharedPreferences)
        ], child: AppRoot(ratesApi: ratesApi)),
      ),
    ),
  );
}
