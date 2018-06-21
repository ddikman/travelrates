import 'dart:async';

import 'package:backpacking_currency_converter/model/country.dart';

import 'package:geolocation/geolocation.dart';
import 'package:geocoder/geocoder.dart';

class CountryDetector {

  Future<CountryResult> detectNewCountry(List<Country> knownCountries) async {
    await _requestGeoPosition();

    final GeolocationResult gpsRequest = await Geolocation.isLocationOperational();
    if (!gpsRequest.isSuccessful) {
      print('geolocation is disabled, cannot detect current country.');
      return CountryResult.failed;
    }

    final gpsLocationRequest = await Geolocation
        .currentLocation(accuracy: LocationAccuracy.city)
        .first;

    if (!gpsLocationRequest.isSuccessful) {
      print("failed to get geolocation: ${gpsLocationRequest.error.toString()}");
      return CountryResult.failed;
    }

    return await _detectCountry(knownCountries, gpsLocationRequest.location);
  }

  Future<Null> _requestGeoPosition() async {
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(const LocationPermission(
      android: LocationPermissionAndroid.fine,
      ios: LocationPermissionIOS.whenInUse,
    ));

    if (!result.isSuccessful) {
      print(
          "failed to get permission for geolocation: ${result.error.toString()}");
    }
  }

  Future<CountryResult> _detectCountry(List<Country> knownCountries, Location location) async {

    final coordinates = new Coordinates(location.latitude, location.longitude);

    try {
      final countryName = await _getCountry(coordinates);

      final country = knownCountries.firstWhere(
              (knownCountry) => knownCountry.name.toLowerCase() == countryName.toLowerCase(),
          orElse: () => null);

      if (country == null) {
        print("unknown country '$countryName' detected");
        return CountryResult.failed;
      }

      return CountryResult.withCountry(country);
    } on Exception catch (e) {
      print("failed to find country based on coordinates [${location.latitude},${location.longitude}]: $e");
      return CountryResult.failed;
    }
  }

  Future<String> _getCountry(Coordinates coordinates) async {
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first.countryName;
  }
}

class CountryResult {

  final Country _country;

  final bool _successful;

  // TODO: any way to make private?
  CountryResult(this._country, this._successful);

  get successful => _successful;

  get country {
    if (!_successful) {
      throw new Exception('detecting the country was not successful, ensure .successful is called to check this before calling .country');
    }
    return _country;
  }

  static withCountry(Country country) {
    return CountryResult(country, true);
  }

  static get failed {
    return CountryResult(null, false);
  }
}