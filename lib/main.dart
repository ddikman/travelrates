import 'package:flutter/material.dart';

import 'package:backpacking_currency_converter/state_container.dart';
import 'package:backpacking_currency_converter/converter_screen.dart';

void main() => runApp(new StateContainer(child: new AppRoot()));

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() {
    return new _AppRootState();
  }
}

class _AppRootState extends State<AppRoot> {

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
      home: state.isLoading ? _buildLoadingScreen() : new ConverterScreen(),
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
}
