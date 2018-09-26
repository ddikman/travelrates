import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/asset_paths.dart';
import 'package:travelconverter/helpers/string_compare.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/services/currency_decoder.dart';
import 'package:travelconverter/services/currency_repository.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:flutter/services.dart';
import 'dart:developer' show Timeline, Flow;
import 'package:meta/meta.dart';

import 'profile.dart';

/// Loads the app state on startup
class StatePersistence {
  final localStorage = new LocalStorage();

  static final log = new Logger<StatePersistence>();

  Future<AppState> load(
      RatesLoader ratesLoader, AssetBundle defaultAssetBundle) async {
    log.debug('loading currencies..');
    final currencyRepository =
        await _loadRepository(ratesLoader, defaultAssetBundle);

    log.debug('loading countries..');
    final countries = await _loadCountries(defaultAssetBundle);
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

  Future<LocalFile> get _stateFile async {
    return await localStorage.getFile('state.json');
  }

  Future<AppState> _loadState(
      CurrencyRepository currencyRepository, List<Country> countries) async {

    // TODO: In case this fail, I need to recover by resetting the settings.
    final stateFile = await localStorage.getFile('state.json');
    final stateJson = json.decode(await stateFile.contents);
    return AppState.fromJson(stateJson, currencyRepository, countries);
  }

  Future<List<Country>> _loadCountries(AssetBundle assets) async {
    final countriesJson = await assets.loadString(AssetPaths.countriesJson);

    final List countriesList = JsonDecoder().convert(countriesJson);
    return countriesList.map((country) => Country.fromJson(country)).toList();
  }

  Future<ByteData> loadAsset(String key) async {
    final Uint8List encoded = utf8.encoder.convert(new Uri(path: Uri.encodeFull(key)).path);
    final ByteData asset =
    await BinaryMessages.send('flutter/assets', encoded.buffer.asByteData());
    if (asset == null)
      throw new FlutterError('Unable to load asset: $key');
    String.fromCharCodes(asset)
    utf8.decoder.convert(codeUnits)
    return utf8.decode(asset.);
  }

  Future<R> compute<Q, R>(ComputeCallback<Q, R> callback, Q message, { String debugLabel }) async {
    profile(() { debugLabel ??= callback.toString(); });
    final Flow flow = Flow.begin();
    Timeline.startSync('$debugLabel: start', flow: flow);
    final ReceivePort resultPort = new ReceivePort();
    Timeline.finishSync();
    final Isolate isolate = await Isolate.spawn(
      _spawn,
      new _IsolateConfiguration<Q, R>(
        callback,
        message,
        resultPort.sendPort,
        debugLabel,
        flow.id,
      ),
      errorsAreFatal: true,
      onExit: resultPort.sendPort,
    );
    final R result = await resultPort.first;
    Timeline.startSync('$debugLabel: end', flow: Flow.end(flow.id));
    resultPort.close();
    isolate.kill();
    Timeline.finishSync();
    return result;
  }

  Future<CurrencyRepository> _loadRepository(
      RatesLoader ratesLoader, AssetBundle assets) async {

    log.debug('line 66..');
    final rates = await ratesLoader.load(assets);

    log.debug('line 69: ${AssetPaths.currenciesJson}, $assets');
    final currencies = await loadAsset(AssetPaths.currenciesJson);

    log.debug('line 72..');
    final decoder = new CurrencyDecoder();
    log.debug('line 73..');
    return await decoder.decode(currencies, rates);
  }

  Future<Null> store(AppState appState) async {
    log.debug('persisting app state..');
    final stateFile = await _stateFile;
    await stateFile.writeContents(json.encode(appState.toJson()));
  }
}

@immutable
class _IsolateConfiguration<Q, R> {
  const _IsolateConfiguration(
      this.callback,
      this.message,
      this.resultPort,
      this.debugLabel,
      this.flowId,
      );
  final ComputeCallback<Q, R> callback;
  final Q message;
  final SendPort resultPort;
  final String debugLabel;
  final int flowId;

  R apply() => callback(message);
}

void _spawn<Q, R>(_IsolateConfiguration<Q, R> configuration) {
  R result;
  Timeline.timeSync(
    '${configuration.debugLabel}',
        () {
      result = configuration.apply();
    },
    flow: Flow.step(configuration.flowId),
  );
  Timeline.timeSync(
    '${configuration.debugLabel}: returning result',
        () { configuration.resultPort.send(result); },
    flow: Flow.step(configuration.flowId),
  );
}