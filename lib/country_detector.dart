import 'dart:async';

import 'package:backpacking_currency_converter/country.dart';

import 'package:geolocation/geolocation.dart';
import 'package:geocoder/geocoder.dart';

class CountryDetector {

  Future<Country> detectNewCountry(List<Country> knownCountries) async {
    await _requestGeoPosition();

    final GeolocationResult gpsRequest = await Geolocation.isLocationOperational();
    if (!gpsRequest.isSuccessful) {
      print('geolocation is disabled, cannot detect current country.');
      return null;
    }

    final gpsLocationRequest = await Geolocation
        .currentLocation(accuracy: LocationAccuracy.city)
        .first;

    if (!gpsLocationRequest.isSuccessful) {
      print("failed to get geolocation: ${gpsLocationRequest.error.toString()}");
      return null;
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

  Future<Country> _detectCountry(List<Country> knownCountries, Location location) async {

    final coordinates = new Coordinates(location.latitude, location.longitude);

    try {
      final countryName = await _getCountry(coordinates);

      final matchingCountry = knownCountries.firstWhere(
              (country) => country.name.toLowerCase() == countryName.toLowerCase(),
          orElse: () => null);

      if (matchingCountry == null) {
        print("unknown country '$countryName' detected");
        return null;
      }

      return matchingCountry;
    } on Exception catch (e) {
      print("failed to find country based on coordinates [${location.latitude},${location.longitude}]: $e");
      return null;
    }
  }

  Future<String> _getCountry(Coordinates coordinates) async {
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first.countryName;
  }
}