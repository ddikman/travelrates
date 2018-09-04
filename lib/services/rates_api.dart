import 'dart:async';

import 'package:travelconverter/model/api_configuration.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:connectivity/connectivity.dart';

import 'package:http/http.dart' as http;

class RatesApi {
  final ApiConfiguration _config;

  static final log = new Logger<RatesApi>();

  RatesApi(this._config);

  Future<AsyncResult<String>> getCurrentRatesJson() async {
    // Check first if we're online
    if (await _isOffline()) {
      log.debug('offline, skipping online rates update');
      return AsyncResult.failed();
    }

    try {
      final response =
          await http.get("${_config.apiUrl}?token=${_config.apiKey}");

      if (response.statusCode != 200) {
        log.error(
            'failed to get currency codes, server responded with status ${response.statusCode}: \r\n${response.body}');
        return AsyncResult.failed();
      }

      return AsyncResult.withValue(response.body);
    } on Exception catch (e) {
      log.error('Failed to retrieve online currency rates: $e}');
      return AsyncResult.failed();
    }
  }

  Future<bool> _isOffline() async {
    var connectivity = new Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.none;
  }
}
