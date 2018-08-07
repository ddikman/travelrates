import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:backpacking_currency_converter/model/api_configuration.dart';
import 'package:flutter/services.dart' show rootBundle;

class ApiConfigurationLoader {
  static const String _configurationPath = 'assets/data/apiConfiguration.json';

  Future<ApiConfiguration> load() {
    return rootBundle.loadStructuredData(_configurationPath,
        (jsonText) async => ApiConfiguration.fromJson(json.decode(jsonText)));
  }
}
