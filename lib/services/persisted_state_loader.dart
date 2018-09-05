
import 'dart:async';

import 'package:moneyconverter/services/rates_loader.dart';
import 'package:moneyconverter/services/state_loader.dart';
import 'package:moneyconverter/services/state_persistence.dart';
import 'package:moneyconverter/state_container.dart';
import 'package:flutter/material.dart';

class PersistedStateLoader implements StateLoader {

  final _ratesLoader = new RatesLoader();

  @override
  Future load(BuildContext context) async {
    // first up get the localizations


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