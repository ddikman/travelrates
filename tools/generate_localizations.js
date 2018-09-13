const fs = require('fs')
const exec = require('child_process').execSync
const indent = require('./indent.js')
const countryLocalizationFileTemplate = require('./country_localizations_file_template.js')
const currencyLocalizationFileTemplate = require('./currency_localizations_file_template.js')

const currencies = JSON.parse(fs.readFileSync('./assets/l10n/currencies.json'))

// all locales are based/mapped on the english locale
const sourceLocale = 'en'
const supportedLocales = [ 'en', 'ja', 'sv' ]

function writeDartFile (path, contents) {
  console.log('writing and formatting dart file..')
  fs.writeFileSync(path, contents)
  exec(`flutter format ${path}`)
  console.log(`written new localizations to: ${path}`)
}

function generateCountries () {
  const countries = JSON.parse(fs.readFileSync('./assets/l10n/countries.json'))

  // since only non-english locales are actually mapped to translations, skip english
  var locales = supportedLocales.filter((locale) => locale !== sourceLocale)
  var allTranslations = locales.map(function (locale) {
    var localizedNames = countries.map(function (countryTranslations) {
      return `"${countryTranslations[sourceLocale]}": "${countryTranslations[locale]}"`
    }).join(',\n\r')

    return `"${locale}": {
${indent(localizedNames, 2)}
    }`
  }).join(',\r\n')

  var contents = countryLocalizationFileTemplate(sourceLocale, allTranslations)
  writeDartFile('./lib/l10n/country_localizations.dart', contents)
}

function generateCurrencies () {
  var allTranslations = supportedLocales.map(function (locale) {
    var currencyCodes = Object.keys(currencies).map(function (code) {
      return `"${code}": "${currencies[code][locale]}"`
    })
    currencyCodes = indent(currencyCodes.join(',\r\n'), 2)
    return `"${locale}": {
      ${currencyCodes}
    }`
  }).join(',\r\n')

  var contents = currencyLocalizationFileTemplate(allTranslations)
  writeDartFile('./lib/l10n/currency_localizations.dart', contents)
}

console.log(`building localization for supported locales: ${supportedLocales}`)
console.log(`basing all locales on the default locale '${sourceLocale}'`)

generateCountries()
generateCurrencies()
