import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:travelconverter/screens/convert/convert_screen.dart';
import 'package:travelconverter/screens/spinner.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/services/state_loader.dart';
import 'package:travelconverter/state_container.dart';
import 'package:travelconverter/widgets/screen_title_text.dart';

class StateLoaderScreen extends StatefulWidget {

  final StateLoader stateLoader;

  const StateLoaderScreen({Key key, this.stateLoader}) : super(key: key);

  @override
  _StateLoaderScreenState createState() {
    return new _StateLoaderScreenState();
  }
}

class _StateLoaderScreenState extends State<StateLoaderScreen> {

  static final log = new Logger<_StateLoaderScreenState>();

  /// Used to wait until spinner fades out
  final GlobalKey<SpinnerState> _spinnerKey = new GlobalKey();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: ScreenTitleText.show(ConvertScreen.screenTitle),
          centerTitle: true,
        ),
        body: _buildSpinner()
    );
  }

  Future _hideSpinner() async {
    // it happened once that the spinner didn't stop so in order to catch
    // it if it happens again I want to log the error
    log.debug('state loaded, hiding spinner..');
    await _spinnerKey.currentState
        .stopLoading()
        .timeout(Duration(seconds: 1), onTimeout: () {
      log.error('Timeout waiting for spinner to finish fadeout..');
    });
  }

  void _chooseLandingScreen() {
    // Add the convert screen instead of this as the "root" route
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) => new ConvertScreen()
    ));

    // if there's no currencies chosen however, allow user to select one
    final appState = StateContainer.of(context).appState;
    if (appState.conversion.currencies.isEmpty) {
      log.debug('no currencies chosen, sending user to add currency screen..');
      Navigator.of(context).pushNamed(AppRoutes.addCurrency);
    }
  }

  _buildSpinner() {
    return new Spinner(key: _spinnerKey, delay: Duration(milliseconds: 500));
  }

  @override
  Future didChangeDependencies() async {
    super.didChangeDependencies();

    // to ensure we only start loading state once
    if (_isLoading)
      return;

    _isLoading = true;
    await widget.stateLoader.load(context)
      .then((val) => _hideSpinner())
      .then((val) => _chooseLandingScreen());
  }
}
