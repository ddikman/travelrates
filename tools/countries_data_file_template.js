const indent = require('./indent.js')

module.exports = function (countries) {

  const countryDeclarations = countries.map(c => {
    return `new Country('${c.name}', '${c.code}', '${c.currency}'),`;
  }).join('\n');

  return `// THIS IS A GENERATED FILE
  // Please don't edit this file. Instead regenerate it with the tools/generate_initial_content.js tool

  import 'package:travelconverter/model/country.dart';

  class CountryData {

    static final List<Country> countries = [
${indent(countryDeclarations, 6)}
    ];
  }`
}
