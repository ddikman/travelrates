const fs = require('fs')
const exec = require('child_process').execSync
const currencyDataFileTemplate = require('./currency_data_file_template.js')
const countriesDataFileTemplate = require('./countries_data_file_template.js')

function writeDartFile (path, contents) {
  console.log('writing and formatting dart file..')
  fs.writeFileSync(path, contents)
  exec(`flutter format ${path}`)
  console.log(`written new localizations to: ${path}`)
}

function generateCurrencies () {
  let currencies = JSON.parse(fs.readFileSync('./assets/data/currencies.json'))
  const rates = JSON.parse(fs.readFileSync('./assets/data/rates.json')).rates
  
  // convert the hash map to a list
  currencies = Object.keys(currencies).map(currencyCode => currencies[currencyCode]);

  // filter discontinued
  currencies = currencies.filter(c => !c.discontinued);

  // set the rate for each currency
  currencies.forEach(currency => {
    currency.rate = parseFloat(rates[currency.code])
  });

  const baseCurrency = currencies.find(c => c.rate === 1);
  var contents = currencyDataFileTemplate(currencies, baseCurrency.code)
  writeDartFile('./lib/data/currency_data.dart', contents)
}

function generateCountries () {
  let countries = JSON.parse(fs.readFileSync('./assets/data/countries.json'))
  var contents = countriesDataFileTemplate(countries)
  writeDartFile('./lib/data/countries_data.dart', contents)
}

generateCurrencies()
generateCountries();