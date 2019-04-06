import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/src/client.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/services/rates_api.dart';
import 'package:travelconverter/services/rates_loader.dart';

import 'mocks/mock_bundle.dart';
import 'mocks/mock_local_storage.dart';

void main() {
  final localStorage = new MockLocalStorage();
  final ratesJson = "ratesjson";
  localStorage.setFile("rates.json", ratesJson);

  final ratesApi = new MockRatesApi();

  final assets = new TestAssetBundle();

  final ratesLoader = new RatesLoader(localStorage: localStorage, ratesApi: ratesApi);

  test('uses cached rates if existing', () async {
    final rates = await ratesLoader.load(assets);
    expect(rates, ratesJson);
  });

  test('returns false result when api fails', () async {
    ratesApi.result = new AsyncResult.failed();

    final rates = await ratesLoader.loadOnlineRates();
    expect(rates.successful, false);
    expect(() => rates.result, throwsA(isInstanceOf<StateError>()));
  });

  test('decodes api json', () async {
    final apiJson = '{"rates":{"EUR":1}}';
    ratesApi.result = new AsyncResult.withValue(apiJson);

    final rates = await ratesLoader.loadOnlineRates();
    expect(rates.successful, true);
    expect(rates.result.length, 1);

    final currency = rates.result.first;
    expect(currency.currencyCode, 'EUR');
    expect(currency.rate, 1.0);
  });

  test('returns failure on invalid api call', () async {
    ratesApi.result = new AsyncResult.withValue("invalid json");
    await expectLater(() => ratesLoader.loadOnlineRates(), throwsA(isInstanceOf<FormatException>()));
  });
}

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