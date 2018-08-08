import 'dart:async';

import 'package:backpacking_currency_converter/model/async_result.dart';
import 'package:backpacking_currency_converter/model/currency_rate.dart';
import 'package:backpacking_currency_converter/services/api_configuration_loader.dart';
import 'package:backpacking_currency_converter/services/currency_decoder.dart';
import 'package:backpacking_currency_converter/services/local_storage.dart';
import 'package:backpacking_currency_converter/services/rates_api.dart';
import 'package:flutter/services.dart';

class RatesLoader {
  final cacheExpirationDate = DateTime.now().add(Duration(days: 1));

  final localStorage = new LocalStorage();

  final decoder = new CurrencyDecoder();

  Future<LocalFile> get _cacheFile async {
    return localStorage.getFile('rates.json');
  }

  Future<bool> _cacheExists() async {
    final file = await _cacheFile;
    return await file.exists;
  }

  Future<String> load(AssetBundle assets) async {
    bool hasCache = await _cacheExists();
    if (hasCache) {
      print('using fresh cached rates');
      return _readCache();
    }

    print(
        'neither cached rates or online rates are available, using installed rates.');
    return await assets.loadString('assets/data/rates.json');
  }

  Future<String> _readCache() async {
    final file = await _cacheFile;
    return file.contents;
  }

  Future<AsyncResult<List<CurrencyRate>>> loadOnlineRates() async {
    final ratesApi = new RatesApi(await new ApiConfigurationLoader().load());
    final ratesJson = await ratesApi.getCurrentRatesJson();
    if (!ratesJson.successful) {
      return AsyncResult.failed();
    }

    try {
      final rates = decoder.decodeRates(ratesJson.result);
      _cacheRates(ratesJson.result);
      return AsyncResult.withValue(rates);
    } on Exception catch (e) {
      print('Online rates invalid json: ${ratesJson.result}');
      throw new FormatException("Online json rates contain invalid json.", e);
    }
  }

  _cacheRates(String rates) async {
    final file = await _cacheFile;
    await file.writeContents(rates);
  }
}
