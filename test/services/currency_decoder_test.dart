import 'dart:io';

import 'package:travelconverter/services/currency_decoder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/assets_folder.dart';

void main() {
  final decoder = new CurrencyDecoder();

  test('can decode the embedded asset files for currencies and rates',
      () async {
    final assets = await AssetsFolder.path;
    var currencies =
        await new File('$assets/data/currencies.json').readAsString();
    var rates = await new File('$assets/data/rates.json').readAsString();
    final repository = await decoder.decode(currencies, rates);

    expect(repository.baseCurrency.code, 'EUR');
  });
}
