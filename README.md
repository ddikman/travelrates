# TravelRates

Handy multi-currency converter specifically for backpackers.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## Building releases

### Api tokens
The hidden api tokens and api url should be stored in json format alike this below in `assets/data/apiConfiguration.json`.

```json
{
  "apiToken": "token",
  "apiUrl": "http://urlpath.com"
}
```

### Android
To build the android release apk you simply run `flutter build apk`. However, before that you'll need to create a local keystore of course.
Make sure you store this some good place (outside of source control) and then reference it in the a `key.properties` file placed in the `android` folder.
This is referenced by the `android/app/build.gradle` signing settings.

## Description

### Short one
Convert between one or more currencies offline. Anytime, anywhere.

### Long one
Martin is a clever backpacker. He doesn't spend more than he has to. He asks people around him what they pay and keeps track of many currencies at once. Martin uses TravelRates for this because keeping track of the difference between dollars, rupies, euros and ringgits is much better left to a phone, it's with him even to the toilet anyway. 

As a backpacker, Martin is often off the grid, offline on a mountain somwhere. No problem. TravelRates updates the currency rates whenever there's wifi but if not, well, the rates from a few days back is good enough.

TravelRates shows him several currencies at the same time, because prices, especially when travelling is sometimes in local currency, sometimes in dollars and he always wants to know what it would cost him 'back home'.

TravelRates helps Martin by skipping those pesky decimals and gives him a clear, easy overview of what's what. Are you like Martin? Maybe TravelRates is for you? 