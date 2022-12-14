import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/services/rates_api.dart';

class MockRatesApi implements RatesApi {
  AsyncResult<String>? result;

  @override
  Future<AsyncResult<String>> getCurrentRatesJson() {
    return Future.value(result);
  }

  @override
  late http.Client client;

  @override
  late Connectivity connectivity;
}
