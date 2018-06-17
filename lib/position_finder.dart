import 'dart:async';

import 'package:backpacking_currency_converter/country.dart';
import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:flutter/material.dart';

import 'package:geolocation/geolocation.dart';
import 'package:geocoder/geocoder.dart';

class PositionFinder extends StatefulWidget {
  final Widget child;

  const PositionFinder({Key key, this.child}) : super(key: key);

  @override
  _PositionFinderState createState() {
    return new _PositionFinderState();
  }
}

class _PositionFinderState extends State<PositionFinder> {
  Future<Null> _loadPosition() async {
    await _requestGeoPosition();

    final GeolocationResult result = await Geolocation.isLocationOperational();
    if (!result.isSuccessful) {
      return;
    }

    Geolocation
        .currentLocation(accuracy: LocationAccuracy.city)
        .listen(_newPosition);
  }

  void _newPosition(LocationResult result) async {
    if (!result.isSuccessful) {
      print("failed to get geolocation: ${result.error.toString()}");
      return;
    }

    final coordinates =
        new Coordinates(result.location.latitude, result.location.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    final countryName = addresses.first.countryName;
    print("looks like you're in $countryName");

    final stateContainer = StateContainer.of(context);
    final state = stateContainer.appState;
    final matchingCountry = state.countries.firstWhere(
        (country) => country.name.toLowerCase() == countryName.toLowerCase(),
        orElse: () => null);
    if (matchingCountry != null) {
      if (!state.currencies.contains(matchingCountry.currencyCode)) {
        print(
            "local currency '${matchingCountry.currencyCode}' is missing, adding it..");
        stateContainer.addCurrency(matchingCountry.currencyCode);
        final currency =
            state.currencyRepo.getCurrencyByCode(matchingCountry.currencyCode);
        _showInformativeSnackbar(matchingCountry, currency);
      } else {
        print("${matchingCountry.currencyCode} already added");
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  void _showInformativeSnackbar(
      Country detectedCountry, Currency detectedCurrency) {
    final tipDisplaySeconds = 10;

    Scaffold.of(context).showSnackBar(new SnackBar(
          duration: Duration(seconds: tipDisplaySeconds),
          action: new SnackBarAction(
            onPressed: () {
              print('closing informative snackbar..');
            },
            label: 'Got it!',
          ),
          content: Text(
              "Hey! Just noticed you're in ${detectedCountry.name}, cool! I've added the local currency, ${detectedCurrency.name} to the conversion list for you. Enjoy!"),
        ));
  }
}
