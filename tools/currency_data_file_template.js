const indent = require('./indent.js')

module.exports = function (currencies, baseCurrency) {

  const currencyDeclarations = currencies.map(c => {
    return `new Currency(symbol: '${c.symbol.replace('$', '\\$')}', code: '${c.code}', name: '${c.name}', icon: '${c.icon}', rate: ${c.rate}),`;
  }).join('\n');

  return `// THIS IS A GENERATED FILE
  // Please don't edit this file. Instead regenerate it with the tools/generate_initial_content.js tool

  import 'package:travelconverter/model/currency.dart';

  class CurrencyData {

    static final String baseCurrency = "${baseCurrency}";
    static final List<Currency> currencies = [
${indent(currencyDeclarations, 6)}
    ];
  }`
}
