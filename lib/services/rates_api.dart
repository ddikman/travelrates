import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:travelconverter/model/api_configuration.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RatesApi {
  final ApiConfiguration _config;
  Connectivity connectivity = new Connectivity();

  http.Client client = new http.Client();

  static final log = new Logger<RatesApi>();

  RatesApi(this._config);

  Future<AsyncResult<String>> getCurrentRatesJson() async {
    // Check first if we're online
    if (await _isOffline()) {
      log.debug('offline, skipping online rates update');
      return AsyncResult.failed();
    }

    try {
      final response = await client
          .get(Uri.parse("${_config.apiUrl}?token=${_config.apiKey}"));

      if (response.statusCode != 200) {
        log.error(
            'failed to get currency codes, server responded with status ${response.statusCode}:\n${response.body}');
        return AsyncResult.failed();
      }

      return AsyncResult.withValue(response.body);
    } on Exception catch (e) {
      log.error('Failed to retrieve online currency rates: $e}');
      return AsyncResult.failed();
    }
  }

  Future<bool> _isOffline() async {
    var connectivityResults = await connectivity.checkConnectivity();
    return connectivityResults.contains(ConnectivityResult.none);
  }
}
