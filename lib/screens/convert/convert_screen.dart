import 'dart:async';

import 'package:backpacking_currency_converter/screens/convert/open_add_currency_screen_button.dart';
import 'package:backpacking_currency_converter/screens/convert/selected_currency_list.dart';
import 'package:backpacking_currency_converter/screens/convert/toggle_configure_button.dart';
import 'package:backpacking_currency_converter/screens/spinner.dart';
import 'package:backpacking_currency_converter/widgets/background_container.dart';
import 'package:backpacking_currency_converter/model/country.dart';
import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/services/country_detector.dart';
import 'package:backpacking_currency_converter/state_container.dart';

import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {
  @override
  _ConvertScreenState createState() {
    return new _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {
  // to get scaffold context and then snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  final CountryDetector _positionFinder = new CountryDetector();

  /// Used to wait until spinner fades out
  GlobalKey<SpinnerState> _spinnerKey = new GlobalKey();

  bool loading;

  @override
  void initState() {
    super.initState();

    loading = true;
    _loadState().whenComplete(_notLoading);
  }

  _notLoading() {
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
      title: new Text("CONVERT"),
      centerTitle: true,
      actions: <Widget>[new ToggleConfigureButton()],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      floatingActionButton: loading ? null : new OpenAddCurrencyScreenButton(),
      body: loading ? _buildSpinner() : _buildCurrencyList(),
    );
  }

  Future<Null> _addNewCountry(CountryResult countryResult) async {
    if (!countryResult.successful) {
      return;
    }

    final country = countryResult.country;

    final stateContainer = StateContainer.of(context);
    final state = stateContainer.appState;
    if (state.currencies.contains(country.currencyCode)) {
      print(
          "detected ${country.name} as current country, currency is already added.");
      return;
    }

    print("local currency '${country.currencyCode}' is missing, adding it..");
    stateContainer.addCurrency(country.currencyCode);
    final currency = state.currencyRepo.getByCode(country.currencyCode);
    _notifyNewCurrencyAdded(country, currency);
  }

  void _notifyNewCurrencyAdded(Country country, Currency currency) {
    final tipDisplaySeconds = 10;

    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: tipDisplaySeconds),
      action: new SnackBarAction(
        label: 'Got it!',
        onPressed: () {
          // user just acknowledged info, no further action needed
        },
      ),
      content: Text(
          "Hey! Just noticed you're in ${country.name}, cool! I've added the local currency, ${currency.name} to the conversion list for you. Enjoy!"),
    ));
  }

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

  Future<Null> _loadState() async {
    final stateContainer = StateContainer.of(context);
    await stateContainer.loadState();
    await _detectCountry(stateContainer.appState);
    await _spinnerKey.currentState.stopLoading();
  }

  Future<Null> _detectCountry(AppState state) async {
    final country = await _positionFinder.detectNewCountry(state.countries);
    await _addNewCountry(country);
  }
}
