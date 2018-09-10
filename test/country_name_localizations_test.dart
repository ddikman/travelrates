import 'dart:io';

import 'package:moneyconverter/l10n/country_name_localizations.dart';
import 'package:test/test.dart';

import 'helpers/assets_folder.dart';

void main() {

  test('can decode the localized countries', () async {
    final assets = await AssetsFolder.path;
    var countries = await new File('$assets/l10n/countries.json').readAsString();

    var countryNames = new CountryNameLocalizations(CountryNameLocalizations.load(countries, 'sv'));

    expect(countryNames.getLocalized('Sweden'), 'Sverige');
  });
}