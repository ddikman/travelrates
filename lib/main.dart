import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/converter_screen.dart';
import 'package:backpacking_currency_converter/currencies_screen.dart';
import 'package:backpacking_currency_converter/loading_screen.dart';
import 'package:flutter/material.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);

    return new MaterialApp(
      title: 'How much is',
      theme: new ThemeData(
          primarySwatch: AppTheme.primaryColor,
          iconTheme: baseTheme.primaryIconTheme.copyWith(color: AppTheme.accentColor),
          hintColor: Colors.transparent, // borders of textfield hints
          textTheme: baseTheme.textTheme
              .copyWith(body1: TextStyle(color: AppTheme.accentColor))),
      home: new LoadingScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => new ConverterScreen(),
        '/addCurrency': (context) => new CurrenciesScreen()
      },
    );
  }
}
