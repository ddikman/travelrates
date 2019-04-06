import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/services/api_configuration_loader.dart';
import 'package:travelconverter/services/currency_decoder.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/services/rates_api.dart';
import 'package:flutter/services.dart';

class RatesLoader {
  static final log = new Logger<RatesLoader>();

  final cacheExpirationDate = DateTime.now().add(Duration(days: 1));

  final LocalStorage localStorage;
  final RatesApi ratesApi;

  final decoder = new CurrencyDecoder();

  RatesLoader({@required this.localStorage, @required this.ratesApi});

  Future<FileOperations> get _cacheFile async {
    return localStorage.getFile('rates.json');
  }

  Future<bool> _cacheExists() async {
    final file = await _cacheFile;
    return await file.exists;
  }

  Future<String> load(AssetBundle assets) async {
    bool hasCache = await _cacheExists();
    if (hasCache) {
      log.debug('using fresh cached rates');
      return _readCache();
    }

    log.debug(
        'neither cached rates or online rates are available, using installed rates.');
    return await assets.loadString('assets/data/rates.json');
  }

  Future<String> _readCache() async {
    final file = await _cacheFile;
    return file.contents;
  }

  Future<AsyncResult<List<CurrencyRate>>> loadOnlineRates() async {
    final ratesJson = await this.ratesApi.getCurrentRatesJson();
    if (!ratesJson.successful) {
      return AsyncResult.failed();
    }

    try {
      final rates = decoder.decodeRates(ratesJson.result);
      _cacheRates(ratesJson.result);
      return AsyncResult.withValue(rates);
    } on Exception catch (e) {
      log.error('Online rates invalid json: ${ratesJson.result}');
      throw new FormatException("Online json rates contain invalid json.", e);
    }
  }

  _cacheRates(String rates) async {
    final file = await _cacheFile;
    await file.writeContents(rates);
  }
}
