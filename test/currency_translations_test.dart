import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/services/currency_decoder.dart';

import 'helpers/assets_folder.dart';

void main() {
  test('all currencies have translations for all supported languages',
      () async {
    final assets = await AssetsFolder.path;
    final currenciesFile = File('$assets/data/currencies.json');
    final ratesFile = File('$assets/data/rates.json');
    final translationsFile = File('$assets/l10n/currencies.json');

    // Load currencies and rates
    final currenciesContent = await currenciesFile.readAsString();
    final ratesContent = await ratesFile.readAsString();
    final decoder = CurrencyDecoder();
    final repository = await decoder.decode(currenciesContent, ratesContent);
    final currencies = repository.getList();

    // Load translations
    final translationsContent = await translationsFile.readAsString();
    final translations =
        jsonDecode(translationsContent) as Map<String, dynamic>;

    // Determine supported languages from the first translation entry
    if (translations.isEmpty) {
      fail('Translations file is empty');
    }
    final firstTranslationEntry =
        translations.values.first as Map<String, dynamic>;
    final supportedLanguages = firstTranslationEntry.keys.toList()..sort();

    // Track missing translations
    final missingTranslations = <String, List<String>>{};

    // Check each currency has translations for all languages
    for (final currency in currencies) {
      final currencyCode = currency.code;
      final currencyTranslations =
          translations[currencyCode] as Map<String, dynamic>?;

      if (currencyTranslations == null) {
        missingTranslations[currencyCode] = supportedLanguages;
        continue;
      }

      // Check each supported language
      for (final language in supportedLanguages) {
        if (!currencyTranslations.containsKey(language) ||
            currencyTranslations[language] == null ||
            (currencyTranslations[language] as String).isEmpty) {
          missingTranslations.putIfAbsent(currencyCode, () => []).add(language);
        }
      }
    }

    // Report missing translations
    if (missingTranslations.isNotEmpty) {
      final buffer = StringBuffer();
      buffer.writeln(
        'Missing translations for ${missingTranslations.length} currency/currencies:',
      );
      buffer.writeln();

      missingTranslations.forEach((currencyCode, missingLanguages) {
        if (missingLanguages.length == supportedLanguages.length) {
          buffer.writeln('  $currencyCode: missing all translations');
        } else {
          buffer.writeln(
              '  $currencyCode: missing ${missingLanguages.join(", ")}');
        }
      });

      buffer.writeln();
      buffer.writeln(
          'All currencies must have translations for: ${supportedLanguages.join(", ")}');

      fail(buffer.toString());
    }

    // Count currencies with complete translations for informational purposes
    print(
      '✓ Verified ${currencies.length} currencies have translations for all supported languages (${supportedLanguages.join(", ")})',
    );
  });
}
