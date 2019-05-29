import 'package:flutter/services.dart';
import 'package:travelconverter/app_root.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/services/api_configuration_loader.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/rates_api.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'package:travelconverter/state_container.dart';

void main() {
  var localStorage = new LocalStorage();
  final ratesApiConfigLoader = new ApiConfigurationLoader();
  ratesApiConfigLoader.load()
    .then((ratesApiConfig) {
      final ratesApi = new RatesApi(ratesApiConfig);
      final statePersistence = new StatePersistence(localStorage: localStorage);
      statePersistence.load(rootBundle).then((state) {
        final appRoot = new AppRoot(ratesApi: ratesApi);
        runApp(new StateContainer(child: appRoot, state: state, statePersistence: statePersistence));
      });
  });
}
