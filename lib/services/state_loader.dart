import 'dart:async';
import 'dart:convert';

import 'package:backpacking_currency_converter/app_state.dart';
import 'package:backpacking_currency_converter/asset_paths.dart';
import 'package:backpacking_currency_converter/helpers/string_compare.dart';
import 'package:backpacking_currency_converter/model/country.dart';
import 'package:backpacking_currency_converter/services/currency_decoder.dart';
import 'package:backpacking_currency_converter/services/currency_repository.dart';
import 'package:backpacking_currency_converter/services/local_storage.dart';
import 'package:backpacking_currency_converter/services/rates_loader.dart';
import 'package:flutter/services.dart';

/// Loads the app state on startup
class StateLoader {
  final localStorage = new LocalStorage();

  Future<AppState> load(
      RatesLoader ratesLoader, AssetBundle defaultAssetBundle) async {
    final currencyRepository =
        await _loadRepository(ratesLoader, defaultAssetBundle);

    final countries = await _loadCountries(defaultAssetBundle);
    countries.sort((a, b) => compareIgnoreCase(a.name, b.name));

    if (await (await _stateFile).exists) {
      print('found persisted state, loading that..');
      return await _loadState(currencyRepository, countries);
    } else {
      print('no persisted state found, opening app with default state..');
      return AppState.initial(
        countries: countries,
        availableCurrencies: currencyRepository,
      );
    }
  }

  Future<LocalFile> get _stateFile async {
    return await localStorage.getFile('state.json');
  }

  Future<AppState> _loadState(
      CurrencyRepository currencyRepository, List<Country> countries) async {
    final stateFile = await localStorage.getFile('state.json');
    final stateJson = json.decode(await stateFile.contents);
    return AppState.fromJson(stateJson, currencyRepository, countries);
  }

  Future<List<Country>> _loadCountries(AssetBundle assets) async {
    final countriesJson = await assets.loadString(AssetPaths.countriesJson);

    final List countriesList = JsonDecoder().convert(countriesJson);
    return countriesList.map((country) => Country.fromJson(country)).toList();
  }

  Future<CurrencyRepository> _loadRepository(
      RatesLoader ratesLoader, AssetBundle assets) async {
    final currencies = await assets.loadString(AssetPaths.currenciesJson);
    final rates = await ratesLoader.load(assets);
    final decoder = new CurrencyDecoder();
    return await decoder.decode(currencies, rates);
  }

  Future<Null> store(AppState appState) async {
    print('persisting app state..');
    final stateFile = await _stateFile;
    await stateFile.writeContents(json.encode(appState.toJson()));
  }
}