import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/data/countries_data.dart';
import 'package:travelconverter/data/currency_data.dart';
import 'package:travelconverter/helpers/string_compare.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/services/currency_repository.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:flutter/services.dart';

/// Loads the app state on startup
class StatePersistence {

  final localStorage;

  static final log = new Logger<StatePersistence>();

  StatePersistence({@required this.localStorage});

  Future<AppState> load(AssetBundle assets) async {
    final currencyRepository = _loadRepository();

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

    // TODO: In case this fail, I need to recover by resetting the settings.
    final stateFile = await localStorage.getFile('state.json');
    final stateJson = json.decode(await stateFile.contents);
    return AppState.fromJson(stateJson, currencyRepository, countries);
  }

  CurrencyRepository _loadRepository() {
    return new CurrencyRepository(
      currencies: CurrencyData.currencies,
      baseRate: CurrencyData.baseCurrency
    );
  }

  Future<Null> store(AppState appState) async {
    log.debug('persisting app state..');
    final stateFile = await _stateFile;
    await stateFile.writeContents(json.encode(appState.toJson()));
  }
}
