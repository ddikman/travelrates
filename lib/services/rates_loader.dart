import 'dart:async';

import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/services/currency_decoder.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/services/rates_api.dart';

class RatesLoader {
  static final log = new Logger<RatesLoader>();

  final LocalStorage localStorage;
  final RatesApi ratesApi;

  final decoder = new CurrencyDecoder();

  RatesLoader({required this.localStorage, required this.ratesApi});

  Future<FileOperations> get _cacheFile async {
    return localStorage.getFile('rates.json');
  }

  Future<bool> _cacheExists() async {
    final file = await _cacheFile;
    return await file.exists;
  }

  Future<String> _readCache() async {
    final file = await _cacheFile;
    return file.contents;
  }

  Future<List<CurrencyRate>> _cachedRates() async {
    String json = '';
    if (await _cacheExists()) {
      try {
        json = await _readCache();
        return decoder.decodeRates(json);
      } on Exception catch (e) {
        log.error(
            'Failed to parse cached local rates: ${e.toString()}\n\r$json');
      }
    }

    return <CurrencyRate>[];
  }

  Future<List<CurrencyRate>> loadOnlineRates() async {
    final ratesJson = await this.ratesApi.getCurrentRatesJson();
    if (!ratesJson.successful || ratesJson.result == null) {
      return await _cachedRates();
    }

    try {
      final rates = decoder.decodeRates(ratesJson.result!);
      _cacheRates(ratesJson.result!);
      return rates;
    } on Exception catch (e) {
      log.error(
          'Online rates invalid json: ${e.toString()}\r\n${ratesJson.result}');
      return await _cachedRates();
    }
  }

  _cacheRates(String rates) async {
    final file = await _cacheFile;
    await file.writeContents(rates);
  }
}
