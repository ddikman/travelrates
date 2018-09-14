# TravelRates

Handy multi-currency converter specifically for backpackers.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## Building releases

### Generating localizations

Run the Intl commands to scrape code for existing messages that need localizations and then generate code files for these.
```bash
$ flutter pub pub run intl_translation:extract_to_arb --output-dir=assets/l10n lib/**/**/*.dart --output-file=intl_en.arb
$ flutter pub pub run intl_translation:generate_from_arb --no-use-deferred-loading --output-dir=lib/l10n lib/**/**/*.dart assets/l10n/intl*.arb
```

To generate new localizations for country names and currencies, with NodeJs v10.9+ run (from project root folder):
```bash
$ node tools/generate_localizations.js
```

This will look at the `countries.json` and `currencies.json` files in `assets/l10n/` and generate output dart files with hardcoded maps into the `lib/l10n/` folder.  

### Api tokens
The hidden api tokens and api url should be stored in json format alike this below in `assets/data/apiConfiguration.json`.

```json
{
  "apiToken": "token",
  "apiUrl": "http://urlpath.com"
}
```

### Android
Before building, review the build configuration in `android/app/build.gradle` to make sure the version number has been incremented.

To build the android release apk you simply run `flutter build apk`. However, before that you'll need to create a local keystore of course.
Make sure you store this some good place (outside of source control) and then reference it in the a `key.properties` file placed in the `android` folder.
This is referenced by the `android/app/build.gradle` signing settings.


### iOS
First up open xcode and in the `Runner > General` section ensure the version number is updated.

From the command line, build an ios package using `flutter build ios --release`.

Then run `Product > Archive` and when that's done click `Validate...`.

When this is done you can do `Upload to App Store...`.

## Description

### Short one
Convert between one or more currencies offline. Anytime, anywhere.

### Long one
Martin is a clever backpacker. He doesn't spend more than he has to. He asks people around him what they pay and keeps track of many currencies at once. Martin uses TravelRates for this because keeping track of the difference between dollars, rupies, euros and ringgits is much better left to a phone, it's with him even to the toilet anyway. 

As a backpacker, Martin is often off the grid, offline on a mountain somwhere. No problem. TravelRates updates the currency rates whenever there's wifi but if not, well, the rates from a few days back is good enough.

TravelRates shows him several currencies at the same time, because prices, especially when travelling is sometimes in local currency, sometimes in dollars and he always wants to know what it would cost him 'back home'.

TravelRates helps Martin by skipping those pesky decimals and gives him a clear, easy overview of what's what. Are you like Martin? Maybe TravelRates is for you? 