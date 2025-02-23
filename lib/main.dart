import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_root.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/services/load_api_configuration.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/preferences.dart';
import 'package:travelconverter/services/rates_api.dart';
import 'package:travelconverter/services/shared_preferences.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'package:travelconverter/state_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var localStorage = LocalStorage();
  final ratesApiConfig = await loadApiConfiguration();
  final ratesApi = RatesApi(ratesApiConfig);
  final statePersistence = StatePersistence(localStorage: localStorage);
  final state = await statePersistence.load(rootBundle);
  final sharedPreferences = await SharedPreferences.initialize(
    prefix: 'travelrates',
  );

  runApp(
    DevicePreview(
      enabled: kDebugMode && false,
      availableLocales: AppLocalizations.supportedLocales,
      builder: (context) => StateContainer(
        child: Builder(
          builder: (ctx) => ProviderScope(overrides: [
            appStateProvider.overrideWithValue(StateContainer.of(ctx).appState),
            stateContainerProvider.overrideWithValue(StateContainer.of(ctx)),
            preferencesProvider.overrideWithValue(sharedPreferences)
          ], child: AppRoot(ratesApi: ratesApi)),
        ),
        state: state,
        statePersistence: statePersistence,
      ),
    ),
  );
}
