import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:travelconverter/services/state_persistence.dart';


class PersistedStateLoader {

  final _ratesLoader = new RatesLoader();

  Future<List<CurrencyRate>> tryLoadRates() async {
    final rates = await _ratesLoader.loadOnlineRates();
    if (rates.successful) {
      return rates.result;
    }

    return new List<CurrencyRate>();
  }

  Future<AppState> loadPreviousState() async {
    final statePersistence = new StatePersistence();

    return await statePersistence.load(_ratesLoader, rootBundle);
  }
}