import 'dart:async';
import 'dart:convert';

import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/data/countries_data.dart';
import 'package:travelconverter/data/currency_data.dart';
import 'package:travelconverter/helpers/string_compare.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/services/currency_repository.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:flutter/services.dart';

/// Loads the app state on startup
class StatePersistence {
  final LocalStorage localStorage;

  static final log = new Logger<StatePersistence>();

  StatePersistence({required this.localStorage});

  Future<AppState> load(AssetBundle assets,
      {List<CurrencyRate>? cachedRates}) async {
    final currencyRepository = _loadRepository(cachedRates);

    final countries = new List<Country>.from(CountryData.countries);
    countries.sort((a, b) => compareIgnoreCase(a.name, b.name));

    if (await (await _stateFile).exists) {
      log.debug('found persisted state, loading that..');
      return await _loadState(currencyRepository, countries);
    } else {
      log.debug('no persisted state found, opening app with default state..');
      return AppState.initial(
        countries: countries,
        availableCurrencies: currencyRepository,
      );
    }
  }

  Future<FileOperations> get _stateFile async {
    return await localStorage.getFile('state.json');
  }

  Future<AppState> _loadState(
      CurrencyRepository currencyRepository, List<Country> countries) async {
    // In case this fail, I need to recover by resetting the settings.
    final stateFile = await localStorage.getFile('state.json');
    final stateJson = json.decode(await stateFile.contents);
    return AppState.fromJson(stateJson, currencyRepository, countries);
  }

  CurrencyRepository _loadRepository(List<CurrencyRate>? cachedRates) {
    // Start with hard-coded currencies
    final currencies = CurrencyData.currencies
        .map((currency) => Currency(
              symbol: currency.symbol,
              code: currency.code,
              name: currency.name,
              icon: currency.icon,
              rate: currency.rate,
            ))
        .toList();

    final repository = CurrencyRepository(
        currencies: currencies, baseRate: CurrencyData.baseCurrency);

    // If we have cached rates, apply them
    if (cachedRates != null && cachedRates.isNotEmpty) {
      log.debug('applying ${cachedRates.length} cached rates to repository..');
      repository.updateRates(cachedRates);
    } else {
      log.debug('no cached rates provided, using hard-coded rates..');
    }

    return repository;
  }

  Future<Null> store(AppState appState) async {
    log.debug('persisting app state..');
    final stateFile = await _stateFile;
    await stateFile.writeContents(json.encode(appState.toJson()));
  }
}
