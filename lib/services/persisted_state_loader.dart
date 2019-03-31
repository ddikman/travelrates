import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:travelconverter/services/state_loader.dart';
import 'package:travelconverter/services/state_persistence.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';


class PersistedStateLoader implements StateLoader {

  final _ratesLoader = new RatesLoader();

  AppState _loadedState;

  List<CurrencyRate> _rates;

  Future preLoad() async {
    final statePersistence = new StatePersistence();

    //final stateContainer = StateContainer.of(context);
    //final defaultAssetBundle = DefaultAssetBundle.of(context);
    _loadedState = _loadedState = await statePersistence
        .load(_ratesLoader, rootBundle);

    // also try to load online rates
    final rates = await _ratesLoader.loadOnlineRates();
    if (rates.successful) {
      _rates = rates.result;
    }
  }

  @override
  Future load(BuildContext context) async {
    final stateContainer = StateContainer.of(context);
    return Future.microtask(() {
      stateContainer.setAppState(_loadedState);
      stateContainer.setRates(_rates);
    });
  }

//  @override
//  Future load(BuildContext context) async {
//    final statePersistence = new StatePersistence();
//
//    final stateContainer = StateContainer.of(context);
//    final defaultAssetBundle = DefaultAssetBundle.of(context);
//    _loadedState = await statePersistence
//        .load(_ratesLoader, defaultAssetBundle)
//        .then((appState) => stateContainer.setAppState(appState));
//
//    // also try to load online rates
//    final rates = await _ratesLoader.loadOnlineRates();
//    if (rates.successful) {
//      stateContainer.setRates(rates.result);
//    }
//  }
}