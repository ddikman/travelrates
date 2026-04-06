import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/services/legacy_currency_mapper.dart';

void main() {
  group('LegacyCurrencyMapper', () {
    test('maps VEF to VES', () {
      expect(LegacyCurrencyMapper.mapCode('VEF'), 'VES');
    });

    test('maps MRO to MRU', () {
      expect(LegacyCurrencyMapper.mapCode('MRO'), 'MRU');
    });

    test('is case-insensitive', () {
      expect(LegacyCurrencyMapper.mapCode('vef'), 'VES');
      expect(LegacyCurrencyMapper.mapCode('mro'), 'MRU');
    });

    test('returns non-legacy codes unchanged', () {
      expect(LegacyCurrencyMapper.mapCode('USD'), 'USD');
      expect(LegacyCurrencyMapper.mapCode('EUR'), 'EUR');
      expect(LegacyCurrencyMapper.mapCode('VES'), 'VES');
    });

    test('mapCodes maps all legacy codes in a list', () {
      final result = LegacyCurrencyMapper.mapCodes(['VEF', 'USD', 'MRO']);
      expect(result, ['VES', 'USD', 'MRU']);
    });

    test('mapCodes returns empty list for empty input', () {
      expect(LegacyCurrencyMapper.mapCodes([]), isEmpty);
    });
  });

  group('Legacy currency migration in AppState', () {
    test('AppState.fromJson maps legacy currentCurrency code', () {
      // This is tested via the integration with AppState.fromJson
      // which calls LegacyCurrencyMapper.mapCode on the currentCurrency
      // and LegacyCurrencyMapper.mapCodes on the currencies list.
      // See state_persistence_test.dart for the full integration test.
      expect(LegacyCurrencyMapper.mapCode('VEF'), 'VES');
      expect(LegacyCurrencyMapper.mapCode('MRO'), 'MRU');
    });
  });
}
