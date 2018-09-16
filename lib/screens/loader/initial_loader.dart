import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:travelconverter/screens/spinner.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/state_container.dart';

class StateLoaderScreen extends StatefulWidget {

  const StateLoaderScreen({Key key}) : super(key: key);

  static final log = new Logger<StateLoaderScreen>();

  @override
  StateLoaderScreenState createState() {
    return new StateLoaderScreenState();
  }
}

class StateLoaderScreenState extends State<StateLoaderScreen> {

  /// Used to wait until spinner fades out
  final GlobalKey<SpinnerState> _spinnerKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(_screenTitle),
          centerTitle: true,
        ),
        body: _buildSpinner()
    );
  }

  Future loadCompleted() async {
    // it happened once that the spinner didn't stop so in order to catch
    // it if it happens again I want to log the error
    await _spinnerKey.currentState
        .stopLoading()
        .timeout(Duration(seconds: 1), onTimeout: () {
      StateLoaderScreen.log.error('Timeout waiting for spinner to finish fadeout..');
    });

    _chooseLandingScreen();
  }

  void _chooseLandingScreen() {
    // home is always home
    Navigator.of(context).pushReplacementNamed(AppRoutes.convert);

    // but we may need to add the first currency as well
    final appState = StateContainer.of(context).appState;
    if (appState.conversion.currencies.isEmpty) {
      Navigator.of(context).pushNamed(AppRoutes.addCurrency);
    }
  }

  _buildSpinner() {
    return new Spinner(key: _spinnerKey, delay: Duration(milliseconds: 500));
  }

  String get _screenTitle => Intl.message(
      "CONVERT", desc: "Convert screen main title"
  );
}
