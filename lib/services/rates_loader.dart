import 'dart:async';
import 'dart:convert';

import 'package:backpacking_currency_converter/model/async_result.dart';
import 'package:backpacking_currency_converter/services/api_configuration_loader.dart';
import 'package:backpacking_currency_converter/services/local_storage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RatesLoader {
  final cacheExpirationDate = DateTime.now().add(Duration(days: 1));

  final configurationLoader = new ApiConfigurationLoader();

  final localStorage = new LocalStorage();

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

  Future<AsyncResult<String>> loadOnlineRates() async {
    // Check first if we're online
    if (await isOffline()) {
      print('offline, skipping online rates update');
      return AsyncResult.failed();
    }

    final apiConfig = await configurationLoader.load();

    try {
      final response =
          await http.get("${apiConfig.apiUrl}?token=${apiConfig.apiKey}");

      if (response.statusCode != 200) {
        print(
            'failed to get currency codes, server responded with status ${response.statusCode}: \r\n${response.body}');
        return AsyncResult.failed();
      }

      // TODO: rewrite to return fully parsed json instead of just validating here
      try {
        final String json = response.body;
        new JsonDecoder().convert(json); // just to validate
        _cacheRates(json);
        return AsyncResult.withValue(response.body);
      } on Exception catch (e) {
        print('Online json rates contain invalid json: $e');
        return AsyncResult.failed();
      }
    } on Exception catch (e) {
      print('Failed to retrieve online currency rates: $e}');
      return AsyncResult.failed();
    }
  }

  _cacheRates(String rates) async {
    final file = await _cacheFile;
    await file.writeContents(rates);
  }

  Future<bool> isOffline() async {
    var connectivity = new Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.none;
  }
}