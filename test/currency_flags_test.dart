import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:country_flags/country_flags.dart';
import 'package:travelconverter/app_core/widgets/currency_icon.dart';
import 'package:travelconverter/services/currency_decoder.dart';

import 'helpers/assets_folder.dart';

void main() {
  test('all currencies have icons and valid flags', () async {
    final assets = await AssetsFolder.path;
    final currenciesFile = File('$assets/data/currencies.json');
    final ratesFile = File('$assets/data/rates.json');

    // Load both currencies.json and rates.json as intended
    final currenciesContent = await currenciesFile.readAsString();
    final ratesContent = await ratesFile.readAsString();
    final decoder = CurrencyDecoder();
    final repository = await decoder.decode(currenciesContent, ratesContent);
    final currencies = repository.getList();

    // Check each currency by attempting to create the flag widget
    final errors = <String>[];
    for (final currency in currencies) {
      final currencyCode = currency.code;
      final icon = currency.icon;

      // Check if currency is missing an icon
      if (icon.isEmpty) {
        errors.add("Missing `icon` field for $currencyCode");
      } else if (CurrencyIcon.hasOverrideAssetIcon(icon)) {
        final assetPath = CurrencyIcon.getLocalAssetPath(icon);
        if (!File(assetPath).existsSync()) {
          errors.add("Missing custom asset file [$icon] for $currencyCode");
        }
      } else if (FlagCode.fromCountryCode(icon.toUpperCase()) == null) {
        errors.add("No such flag country code [$icon] for $currencyCode");
      }
    }

    if (errors.isNotEmpty) {
      final errorList = errors.join('\n');
      fail(
        'Invalid or unsupported flag codes for ${errors.length} currency/currencies:\n'
        '$errorList\n\n'
        'These country codes are not supported by the country_flags package.',
      );
    }

    // ignore: avoid_print
    print('✓ Verified ${currencies.length} currencies have icons and valid flags');
  });
}
