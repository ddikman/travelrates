import 'dart:async';

import 'package:intl/intl.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/screens/convert/open_add_currency_screen_button.dart';
import 'package:travelconverter/screens/convert/selected_currency_list.dart';
import 'package:travelconverter/screens/convert/toggle_configure_button.dart';
import 'package:travelconverter/screens/spinner.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/services/state_loader.dart';
import 'package:travelconverter/widgets/background_container.dart';
import 'package:travelconverter/state_container.dart';

import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {

  final StateLoader stateLoader;

  const ConvertScreen({Key key, this.stateLoader}) : super(key: key);

  @override
  _ConvertScreenState createState() {
    return new _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {
  // Keep a key for scaffold to use when showing snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  /// Used to wait until spinner fades out
  GlobalKey<SpinnerState> _spinnerKey = new GlobalKey();

  bool loading;

  static final log = new Logger<_ConvertScreenState>();

  @override
  void initState() {
    super.initState();

    _showLoader();

    // TODO: This is a really nasty fix, simply to make sure initState finish executing before this method completes
    Future.delayed(Duration(milliseconds: 10))
      .then((val) => widget.stateLoader.load(context))
      .then((val) => _hideLoader())
      .then((val) => _addCurrenciesIfMissing());
  }

  void _addCurrenciesIfMissing() {
    final appState = StateContainer.of(context).appState;
    if (appState.conversion.currencies.isEmpty) {
      Navigator.of(context).pushNamed(AppRoutes.addCurrency);
    }
  }

  void _showLoader() {
    setState(() => loading = true);
  }

  Future _hideLoader() async {

    // it happened once that the spinner didn't stop so in order to catch
    // it if it happens again I want to log the error
    await _spinnerKey.currentState
        .stopLoading()
        .timeout(Duration(seconds: 1), onTimeout: () {
      log.error('Timeout waiting for spinner to finish fadeout..');
    });

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: _buildSpinner()
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(actions: <Widget>[new ToggleConfigureButton()]),
      body: _buildCurrencyList(),
      floatingActionButton: new OpenAddCurrencyScreenButton(),
    );
  }

  AppBar _buildAppBar({List<Widget> actions = const <Widget>[]}) {
    return new AppBar(
      title: new Text(_screenTitle),
      centerTitle: true,
      actions: actions,
    );
  }

  String get _screenTitle => Intl.message(
      "CONVERT", desc: "Convert screen main title"
  );

  _buildSpinner() {
    return new Spinner(key: _spinnerKey, delay: Duration(milliseconds: 500));
  }

  _buildCurrencyList() {
    const _floatingButtonSpacing = 60.0;

    return new BackgroundContainer(
        // padding the body bottom stops the floating space button from
        // hiding the lowermost content
        child: new Padding(
      padding: const EdgeInsets.only(bottom: _floatingButtonSpacing),
      child: new SelectedCurrencyList(),
    ));
  }
}
