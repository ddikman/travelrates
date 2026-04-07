import 'dart:io';

import 'package:travelconverter/services/currency_decoder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/assets_folder.dart';

void main() {
  final decoder = CurrencyDecoder();

  test('can decode the embedded asset files for currencies and rates',
      () async {
    final assets = await AssetsFolder.path;
    var currencies =
        await File('$assets/data/currencies.json').readAsString();
    var rates = await File('$assets/data/rates.json').readAsString();
    final repository = await decoder.decode(currencies, rates);

    expect(repository.baseCurrency.code, 'EUR');
  });

  group('decodeRates', () {
    test('decodes rates correctly', () {
      final json = '{"rates":{"USD":1.17,"EUR":1.0,"GBP":0.87}}';
      final result = decoder.decodeRates(json);

      expect(result.rates.length, 3);
      expect(result.rates[0].currencyCode, 'USD');
      expect(result.rates[0].rate, 1.17);
      expect(result.rates[1].currencyCode, 'EUR');
      expect(result.rates[1].rate, 1.0);
      expect(result.rates[2].currencyCode, 'GBP');
      expect(result.rates[2].rate, 0.87);
    });

    test('extracts timestamp when present', () {
      final expected = DateTime.utc(2025, 12, 29, 23, 54, 4);
      final unixSeconds = expected.millisecondsSinceEpoch ~/ 1000;
      final json = '{"timestamp":$unixSeconds,"rates":{"USD":1.17,"EUR":1.0}}';
      final result = decoder.decodeRates(json);

      expect(result.timestamp, isNotNull);
      expect(result.timestamp!.toUtc(), expected);
    });

    test('handles missing timestamp gracefully', () {
      final json = '{"rates":{"USD":1.17,"EUR":1.0}}';
      final result = decoder.decodeRates(json);

      expect(result.rates.length, 2);
      expect(result.timestamp, isNull);
    });

    test('handles invalid timestamp type gracefully', () {
      final json = '{"timestamp":"invalid","rates":{"USD":1.17}}';
      final result = decoder.decodeRates(json);

      expect(result.rates.length, 1);
      expect(result.timestamp, isNull);
    });

    test('converts Unix timestamp to DateTime correctly', () {
      // Unix timestamp for 2025-01-15 12:00:00 UTC
      final unixTimestamp = 1736942400;
      final json = '{"timestamp":$unixTimestamp,"rates":{"USD":1.17}}';
      final result = decoder.decodeRates(json);

      expect(result.timestamp, isNotNull);
      final expectedDate =
          DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
      expect(result.timestamp, expectedDate);
    });

    test('handles base rate as integer', () {
      final json = '{"rates":{"EUR":1,"USD":1.17}}';
      final result = decoder.decodeRates(json);

      expect(result.rates.length, 2);
      expect(result.rates[0].currencyCode, 'EUR');
      expect(result.rates[0].rate, 1.0);
    });

    test('throws error when rates key is missing', () {
      final json = '{"timestamp":1767052444}';

      expect(() => decoder.decodeRates(json), throwsArgumentError);
    });

    test('handles real API response format', () {
      final json = '''
      {
        "success":true,
        "timestamp":1767052444,
        "base":"EUR",
        "date":"2025-12-30",
        "rates":{
          "USD":1.17717,
          "GBP":0.871447,
          "SEK":10.80838
        }
      }
      ''';
      final result = decoder.decodeRates(json);

      expect(result.rates.length, 3);
      expect(result.timestamp, isNotNull);
      expect(result.rates.any((r) => r.currencyCode == 'USD'), true);
      expect(result.rates.any((r) => r.currencyCode == 'GBP'), true);
      expect(result.rates.any((r) => r.currencyCode == 'SEK'), true);
    });
  });
}
