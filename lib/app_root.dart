import 'package:backpacking_currency_converter/add_currency_screen.dart';
import 'package:backpacking_currency_converter/app_routes.dart';
import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/converter_screen.dart';
import 'package:backpacking_currency_converter/loading_screen.dart';
import 'package:flutter/material.dart';

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
    return new MaterialApp(
      title: 'How much is',
      theme: _constructTheme(),
      home: new LoadingScreen(),
      routes: <String, WidgetBuilder>{
        AppRoutes.home: (context) => new ConvertScreen(),
        AppRoutes.addCurrency: (context) => new AddCurrencyScreen()
      },
    );
  }

  _constructTheme() {
    final baseTheme = Theme.of(context);

    final textTheme = baseTheme.textTheme.copyWith(
        body1: TextStyle(color: AppTheme.accentColor)
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