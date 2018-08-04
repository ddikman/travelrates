
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class RatesLoader {

  final cacheExpirationDate = DateTime.now().add(Duration(days: 1));

  Future<File> get _cacheFile async {
    final directory = await _localDirectory;
    return new File('$directory/rates.json');
  }

  Future<String> get _localDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _cacheExists() async {
    final file = await _cacheFile;
    return await file.exists();
  }

  Future<String> load(AssetBundle assets) async {
    bool hasCache = await _cacheExists();
    if (hasCache) {
      print('using fresh cached rates');
      return _readCache();
    }

    print('neither cached rates or online rates are available, using installed rates.');
    return await assets.loadString('assets/data/rates.json');
  }

  Future<String> _readCache() async {
    final file = await _cacheFile;
    return file.readAsString();
  }

  Future<OnlineRatesResult> loadOnlineRates() async {

    // Check first if we're online
    if (await isOffline()) {
      print('offline, skipping online rates update');
      return OnlineRatesResult.notAvailable();
    }

    // TODO: committed token
    // yes these both are hardcoded and committed to git history now
    // but it's fine, the token will be changed before publishing this
    const apiToken = '8c09d1b2106a42329c735e807a22d587';
    const apiUrl = 'http://currencyrates.greycastle.se/';

    try {
      final response = await http.get("$apiUrl?token=$apiToken");

      if (response.statusCode != 200) {
        print('failed to get currency codes, server responded with status ${response.statusCode}: \r\n${response.body}');
        return OnlineRatesResult.notAvailable();
      }

      // TODO: rewrite to return fully parsed json instead of just validating here
      try {
        final String json = response.body;
        new JsonDecoder().convert(json); // just to validate
        _cacheRates(json);
        return OnlineRatesResult.withRates(response.body);
      } on Exception catch (e) {
        print('Online json rates contain invalid json: $e');
        return OnlineRatesResult.notAvailable();
      }
    } on Exception catch (e) {
      print('Failed to retrieve online currency rates: $e}');
      return OnlineRatesResult.notAvailable();
    }
  }

  _cacheRates(String rates) async {
    final file = await _cacheFile;
    await file.writeAsString(rates);
  }

  Future<bool> isOffline() async {
    var connectivity = new Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.none;
  }
}

class OnlineRatesResult {

  final String _rates;

  final bool available;

  OnlineRatesResult.notAvailable() : this._rates = null, this.available = false;

  OnlineRatesResult.withRates(String rates) : this._rates = rates, this.available = true;

  String get rates {
    if (!available) {
      throw StateError("Cannot get rates when request is not successful, make sure to call .successful first");
    }
    return _rates;
  }
}