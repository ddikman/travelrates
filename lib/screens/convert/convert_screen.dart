import 'dart:async';

import 'package:backpacking_currency_converter/app_routes.dart';
import 'package:backpacking_currency_converter/screens/convert/open_add_currency_screen_button.dart';
import 'package:backpacking_currency_converter/screens/convert/selected_currency_list.dart';
import 'package:backpacking_currency_converter/screens/convert/toggle_configure_button.dart';
import 'package:backpacking_currency_converter/screens/spinner.dart';
import 'package:backpacking_currency_converter/services/rates_loader.dart';
import 'package:backpacking_currency_converter/services/state_loader.dart';
import 'package:backpacking_currency_converter/widgets/background_container.dart';
import 'package:backpacking_currency_converter/state_container.dart';

import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {
  @override
  _ConvertScreenState createState() {
    return new _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {
  // Keep a key for scaffold to use when showing snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  final _ratesLoader = new RatesLoader();

  /// Used to wait until spinner fades out
  GlobalKey<SpinnerState> _spinnerKey = new GlobalKey();

  bool loading;

  @override
  void initState() {
    super.initState();

    _showLoader();
    _loadState()
        .whenComplete(_hideLoader)
        .whenComplete(_addCurrenciesIfMissing);
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

  void _hideLoader() {
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
      title: new Text("CONVERT"),
      centerTitle: true,
      actions: actions,
    );
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
    final defaultAssetBundle = DefaultAssetBundle.of(context);

    final statePersistence = new StateLoader();

    final stateContainer = StateContainer.of(context);
    await statePersistence
        .load(_ratesLoader, defaultAssetBundle)
        .then((appState) => stateContainer.setAppState(appState));

    // also try to load online rates
    final rates = await _ratesLoader.loadOnlineRates();
    if (rates.successful) {
      stateContainer.setRates(rates.result);
    }

    await _spinnerKey.currentState
        .stopLoading()
        .timeout(Duration(seconds: 1), onTimeout: () {
          print('Timed out waiting for spinner to finish fadeout..');
    });
  }
}
