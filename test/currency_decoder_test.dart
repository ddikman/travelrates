import 'dart:io';

import 'package:backpacking_currency_converter/services/currency_decoder.dart';
import 'package:test/test.dart';

import 'helpers/assets_folder.dart';

void main() {

  final decoder = new CurrencyDecoder();

  test('can decode the embedded asset files for currencies and rates', () async {
    final assets = AssetsFolder.path;
    var currencies = await new File('$assets/currencies.json').readAsString();
    var rates = await new File('$assets/rates.json').readAsString();
    final repository = await decoder.decode(currencies, rates);

    expect(repository.baseCurrency.code, 'EUR');
  });
}