import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:country_flags/country_flags.dart';
import 'package:travelconverter/helpers/flag_helper.dart';
import 'package:travelconverter/services/currency_decoder.dart';

import 'helpers/assets_folder.dart';

void main() {
  test('all currencies have icons and valid flags', () async {
    final assets = await AssetsFolder.path;
    final currenciesFile = File('$assets/data/currencies.json');
    final ratesFile = File('$assets/data/rates.json');
    final flagsDirectory = Directory('$assets/flags');

    // Load both currencies.json and rates.json as intended
    final currenciesContent = await currenciesFile.readAsString();
    final ratesContent = await ratesFile.readAsString();
    final decoder = CurrencyDecoder();
    final repository = await decoder.decode(currenciesContent, ratesContent);
    final currencies = repository.getList();

    // Track currencies missing icons and invalid flags
    final missingIcons = <String>[];
    final invalidFlags = <String>[];
    final missingLocalAssets = <String>[];

    // Check each currency by attempting to create the flag widget
    for (final currency in currencies) {
      final currencyCode = currency.code;
      final icon = currency.icon;

      // Check if currency is missing an icon
      if (icon.isEmpty) {
        missingIcons.add(currencyCode);
        continue;
      }

      // Check if this currency uses a local asset
      if (FlagHelper.shouldUseLocalAsset(icon)) {
        // Verify the local asset file exists
        final assetFile = File('$assets/flags/$icon.png');
        if (!await assetFile.exists()) {
          missingLocalAssets.add(currencyCode);
        }
        continue;
      }

      // Try to create a flag widget - this will throw if the country code is invalid
      try {
        CountryFlag.fromCountryCode(icon);
        // If we get here, the flag widget was created successfully
      } catch (e) {
        // Flag creation failed, record it
        invalidFlags.add(currencyCode);
      }
    }

    // Report missing icons
    if (missingIcons.isNotEmpty) {
      final missingList = missingIcons.join('\n');
      fail(
        'Missing icons for ${missingIcons.length} currency/currencies:\n'
        '$missingList\n\n'
        'All currencies must have an icon field set.',
      );
    }

    // Report missing local assets
    if (missingLocalAssets.isNotEmpty) {
      final missingList = missingLocalAssets.join('\n');
      fail(
        'Missing local asset files for ${missingLocalAssets.length} currency/currencies:\n'
        '$missingList\n\n'
        'Expected asset files in: $flagsDirectory',
      );
    }

    // Report invalid flags
    if (invalidFlags.isNotEmpty) {
      final invalidList = invalidFlags.join('\n');
      fail(
        'Invalid or unsupported flag codes for ${invalidFlags.length} currency/currencies:\n'
        '$invalidList\n\n'
        'These country codes are not supported by the country_flags package.',
      );
    }

    // Count currencies with icons for informational purposes
    // Note: discontinued currencies are already filtered out by CurrencyDecoder
    print(
      '✓ Verified ${currencies.length} currencies have icons and valid flags',
    );
  });
}
