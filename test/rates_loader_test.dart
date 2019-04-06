import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/services/rates_loader.dart';

import 'mocks/mock_bundle.dart';
import 'mocks/mock_local_storage.dart';

void main() {
  final localStorage = new MockLocalStorage();
  final ratesJson = "ratesjson";
  localStorage.setFile("rates.json", ratesJson);

  final assets = new TestAssetBundle();

  test('uses cached rates if existing', () async {
    final ratesLoader = new RatesLoader(localStorage: localStorage);
    final rates = await ratesLoader.load(assets);
    expect(rates, ratesJson);
  });
}