import 'package:flutter/material.dart';

import 'package:backpacking_currency_converter/state_container.dart';
import 'package:backpacking_currency_converter/currencies_screen.dart';
import 'package:backpacking_currency_converter/converter_screen.dart';
import 'package:backpacking_currency_converter/base_currency_screen.dart';

void main() => runApp(new StateContainer(child: new AppRoot()));

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() {
    return new _AppRootState();
  }
}

class _AppRootState extends State<AppRoot> {
  String _selectedScreen = 'Conversion';

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    final baseTheme = Theme.of(context);

    return new MaterialApp(
      title: 'Backpacker currency control',
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: baseTheme.primaryIconTheme.copyWith(color: Colors.white),
          textTheme: baseTheme.textTheme
              .copyWith(body1: TextStyle(color: Colors.white))),
      home: _wrapWithGradientBackground(
          state.isLoading ? _buildLoadingScreen() : _buildHomeScreen()),
    );
  }

  Widget _buildNavigationDropDown() {
    final screens = <String>[
      'Conversion',
      'Manage currencies',
      'Set base currency'
    ];

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return screens
            .map((screen) => PopupMenuItem<String>(
                  value: screen,
                  child: Text(screen),
                ))
            .toList();
      },
      icon: Icon(Icons.dehaze),
      onSelected: (screen) {
        setState(() {
          _selectedScreen = screen;
        });
      },
    );
  }

  _buildLoadingScreen() {
    final loaderColor = AlwaysStoppedAnimation<Color>(Colors.white);
    return new Center(
        child: new Container(
      width: 120.0,
      height: 120.0,
      child: CircularProgressIndicator(
        strokeWidth: 5.0,
        valueColor: loaderColor,
      ),
    ));
  }

  _wrapWithGradientBackground(Widget widget) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.blue[100],
            Colors.blue[300],
          ])),
      child: widget,
    );
  }

  _buildHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedScreen),
        actions: <Widget>[_buildNavigationDropDown()],
      ),
      body: _wrapWithGradientBackground(_buildCurrentScreen()),
    );
  }

  _buildCurrentScreen() {
    switch (_selectedScreen) {
      case "Set base currency":
        return BaseCurrencyScreen();
      case "Manage currencies":
        return CurrenciesScreen();
      case "Conversion":
        return ConverterScreen();
    }

    throw StateError("Unknown screen: " + _selectedScreen);
  }
}
