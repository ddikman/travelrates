import 'dart:io';

import 'package:backpacking_currency_converter/services/currency_decoder.dart';
import 'package:test/test.dart';

void main() {

  final decoder = new CurrencyDecoder();

  test('can decode the embedded asset files for currencies and rates', () async {
    final assetPath = Platform.script.resolve('./assets/data').toFilePath();
    print('Assets are located at $assetPath');

    var currencies = await new File('$assetPath/currencies.json').readAsString();
    var rates = await new File('$assetPath/rates.json').readAsString();
    final repository = await decoder.decode(currencies, rates);

    expect(repository.baseCurrency.code, 'EUR');
  });
}