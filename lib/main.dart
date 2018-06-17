import 'dart:async';

import 'package:backpacking_currency_converter/converter_screen.dart';
import 'package:backpacking_currency_converter/currencies_screen.dart';
import 'package:backpacking_currency_converter/loading_screen.dart';
import 'package:flutter/material.dart';

import 'package:geolocation/geolocation.dart';
import 'package:geocoder/geocoder.dart';

import 'package:backpacking_currency_converter/state_container.dart';

void main() => runApp(new StateContainer(child: new AppRoot()));

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() {
    return new _AppRootState();
  }
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    _loadPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);

    return new MaterialApp(
      title: 'Backpacker currency control',
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: baseTheme.primaryIconTheme.copyWith(color: Colors.white),
          hintColor: Colors.transparent, // borders of textfield hints
          textTheme: baseTheme.textTheme
              .copyWith(body1: TextStyle(color: Colors.white))),
      home: new LoadingScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => new ConverterScreen(),
        '/addCurrency': (context) => new CurrenciesScreen()
      },
    );
  }

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

    print("looks like you're in ${addresses.first.countryName}");
  }

  Future<Null> _requestGeoPosition() async {
    final GeolocationResult result = await Geolocation.requestLocationPermission(const LocationPermission(
      android: LocationPermissionAndroid.fine,
      ios: LocationPermissionIOS.whenInUse,
    ));

    if(!result.isSuccessful) {
      print("failed to get permission for geolocation: ${result.error.toString()}");
    }
  }
}
