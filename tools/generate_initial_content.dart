import 'dart:convert';
import 'dart:io';

String indent(String text, int spaces) {
  final prefix = ' ' * spaces;
  return text.replaceAllMapped(RegExp(r'^(?=.)', multiLine: true), (m) => prefix);
}

String buildCurrencyDataFile(List<Map<String, dynamic>> currencies, String baseCurrency) {
  final declarations = currencies.map((c) {
    final symbol = (c['symbol'] as String).replaceAll(r'$', r'\$');
    return "Currency(symbol: '$symbol', code: '${c['code']}', name: '${c['name']}', icon: '${c['icon']}', rate: ${c['rate']}),";
  }).join('\n');

  return '''// THIS IS A GENERATED FILE
  // Please don't edit this file. Instead regenerate it with the tools/generate_initial_content.dart tool

  import 'package:travelconverter/model/currency.dart';

  class CurrencyData {

    static final String baseCurrency = "$baseCurrency";
    static final List<Currency> currencies = [
${indent(declarations, 6)}
    ];
  }''';
}

String buildCountriesDataFile(List<dynamic> countries) {
  final declarations = countries.map((c) {
    return "Country('${c['name']}', '${c['code']}', '${c['currency']}'),";
  }).join('\n');

  return '''// THIS IS A GENERATED FILE
  // Please don't edit this file. Instead regenerate it with the tools/generate_initial_content.dart tool

  import 'package:travelconverter/model/country.dart';

  class CountryData {

    static final List<Country> countries = [
${indent(declarations, 6)}
    ];
  }''';
}

void writeDartFile(String path, String contents) {
  print('writing and formatting dart file..');
  File(path).writeAsStringSync(contents);
  Process.runSync('fvm', ['dart', 'format', path]);
  print('written new data to: $path');
}

void main() {
  // Generate currencies
  final currenciesMap = jsonDecode(
    File('assets/data/currencies.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final rates = (jsonDecode(
    File('assets/data/rates.json').readAsStringSync(),
  ) as Map<String, dynamic>)['rates'] as Map<String, dynamic>;

  var currencies = currenciesMap.values
      .cast<Map<String, dynamic>>()
      .where((c) => c['discontinued'] != true)
      .map((c) => {...c, 'rate': double.parse(rates[c['code']].toString())})
      .toList();

  final baseCurrency = currencies.firstWhere((c) => c['rate'] == 1.0);
  writeDartFile('lib/data/currency_data.dart', buildCurrencyDataFile(currencies, baseCurrency['code'] as String));

  // Generate countries
  final countries = jsonDecode(
    File('assets/data/countries.json').readAsStringSync(),
  ) as List<dynamic>;
  writeDartFile('lib/data/countries_data.dart', buildCountriesDataFile(countries));
}
