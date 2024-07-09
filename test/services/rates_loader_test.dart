import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/services/rates_loader.dart';

import '../mocks/mock_local_storage.dart';
import '../mocks/mock_rates_api.dart';

void main() {
  final localStorage = new MockLocalStorage();

  final ratesApi = new MockRatesApi();

  final ratesLoader =
      new RatesLoader(localStorage: localStorage, ratesApi: ratesApi);

  test('uses cached rates if online rates cannot be retrieved', () async {
    // given
    ratesApi.result = new AsyncResult.failed();
    localStorage.setFile("rates.json", '{"rates": {"SEK": 3.3}}');

    final rates = await ratesLoader.loadOnlineRates();
    expect(rates.length, 1);
    expect(rates[0].currencyCode, 'SEK');
    expect(rates[0].rate, 3.3);
  });

  test('returns empty list if cache is corrupt', () async {
    localStorage.setFile("rates.json", 'not a json');
    ratesApi.result = new AsyncResult.failed();

    final rates = await ratesLoader.loadOnlineRates();
    expect(rates.length, 0);
  });

  test('returns cache if online rates are corrupt', () async {
    localStorage.setFile("rates.json", '{"rates": {"GBP": 2.8}}');
    ratesApi.result = new AsyncResult.withValue('invalid json');

    final rates = await ratesLoader.loadOnlineRates();
    expect(rates.length, 1);
    expect(rates[0].currencyCode, 'GBP');
    expect(rates[0].rate, 2.8);
  });

  test('decodes api json', () async {
    final apiJson = '{"rates":{"USD":2.1}}';
    ratesApi.result = new AsyncResult.withValue(apiJson);

    final rates = await ratesLoader.loadOnlineRates();
    expect(rates.length, 1);
    expect(rates[0].currencyCode, 'USD');
    expect(rates[0].rate, 2.1);
  });

  test('caches rates on success', () async {
    final apiJson = '{"rates":{"USD":2.1}}';
    ratesApi.result = new AsyncResult.withValue(apiJson);

    await ratesLoader.loadOnlineRates();
    final cacheFile = await localStorage.getFile("rates.json");
    final cachedContents = await cacheFile.contents;
    expect(cachedContents, apiJson);
  });
}
