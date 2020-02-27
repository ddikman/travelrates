import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/services/rates_api.dart';

class MockRatesApi implements RatesApi {

  AsyncResult<String> result;

  @override
  Future<AsyncResult<String>> getCurrentRatesJson() {
    return Future.value(result);
  }

  @override
  Client client;

  @override
  Connectivity connectivity;
}