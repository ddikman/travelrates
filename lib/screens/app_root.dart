import 'package:backpacking_currency_converter/screens/add_currency/add_currency_screen.dart';
import 'package:backpacking_currency_converter/app_routes.dart';
import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/screens/convert/convert_screen.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() {
    return new _AppRootState();
  }
}

class _AppRootState extends State<AppRoot> {

  final mainScreen = new ConvertScreen();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TravelRates',
      theme: _constructTheme(),
      home: mainScreen,
      routes: <String, WidgetBuilder>{
        AppRoutes.home: (context) => mainScreen,
        AppRoutes.addCurrency: (context) => new AddCurrencyScreen()
      },
    );
  }

  _constructTheme() {
    final baseTheme = Theme.of(context);


    const baseFont = 'Tahoma';
    final baseTextStyle = TextStyle(
        color: AppTheme.accentColor,
        fontFamily: baseFont
    );

    final textTheme = baseTheme.textTheme.copyWith(
        display1: baseTextStyle.copyWith(),
        body1: baseTextStyle.copyWith(),
    );

    final iconTheme = baseTheme.primaryIconTheme.copyWith(
        color: AppTheme.accentColor
    );

    return new ThemeData(
      primarySwatch: AppTheme.primaryColor,
      iconTheme: iconTheme,
      hintColor: AppTheme.accentColor, // borders of textfield hints
      textTheme: textTheme,
    );
  }
}
