import 'dart:io';

import 'package:backpacking_currency_converter/services/currency_decoder.dart';
import 'package:test/test.dart';

void main() {

  final decoder = new CurrencyDecoder();

  test('can decode the embedded asset files for currencies and rates', () async {
    const basePath = './assets/data';
    var currencies = await new File('$basePath/currencies.json').readAsString();
    var rates = await new File('$basePath/rates.json').readAsString();
    final repository = await decoder.decode(currencies, rates);

    expect(repository.baseCurrency.code, 'EUR');
  });
}