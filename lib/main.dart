import 'package:flutter/services.dart';
import 'package:travelconverter/app_root.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/services/load_api_configuration.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/rates_api.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'package:travelconverter/state_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var localStorage = LocalStorage();
  final ratesApiConfig = await loadApiConfiguration();
  final ratesApi = RatesApi(ratesApiConfig);
  final statePersistence = StatePersistence(localStorage: localStorage);
  final state = await statePersistence.load(rootBundle);

  runApp(new StateContainer(
      child: AppRoot(ratesApi: ratesApi),
      state: state,
      statePersistence: statePersistence));
}
