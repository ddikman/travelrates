
import 'dart:async';

import 'package:backpacking_currency_converter/services/rates_loader.dart';
import 'package:backpacking_currency_converter/services/state_loader.dart';
import 'package:backpacking_currency_converter/services/state_persistence.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:flutter/material.dart';

class PersistedStateLoader implements StateLoader {

  final _ratesLoader = new RatesLoader();

  @override
  Future load(BuildContext context) async {
    final statePersistence = new StatePersistence();

    final stateContainer = StateContainer.of(context);
    final defaultAssetBundle = DefaultAssetBundle.of(context);
    await statePersistence
        .load(_ratesLoader, defaultAssetBundle)
        .then((appState) => stateContainer.setAppState(appState));

    // also try to load online rates
    final rates = await _ratesLoader.loadOnlineRates();
    if (rates.successful) {
      stateContainer.setRates(rates.result);
    }
  }
}