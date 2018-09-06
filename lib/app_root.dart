
import 'package:moneyconverter/l10n/fallback_material_localisations_delegate.dart';
import 'package:moneyconverter/screens/add_currency/add_currency_screen.dart';
import 'package:moneyconverter/app_routes.dart';
import 'package:moneyconverter/app_theme.dart';
import 'package:moneyconverter/screens/convert/convert_screen.dart';
import 'package:moneyconverter/l10n/app_localizations_delegate.dart';
import 'package:moneyconverter/services/state_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppRoot extends StatefulWidget {

  /// injected to allow for state loading replacement
  final StateLoader stateLoader;

  const AppRoot({Key key, this.stateLoader}) : super(key: key);

  @override
  _AppRootState createState() {
    return new _AppRootState();
  }
}

class _AppRootState extends State<AppRoot> {

  ConvertScreen mainScreen;

  @override
  void initState() {
    mainScreen = new ConvertScreen(stateLoader: widget.stateLoader);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TravelRates',
      theme: _constructTheme(),
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const FallbackMaterialLocalisationsDelegate()
      ],
      supportedLocales: AppLocalizationsDelegate.supportedLocales,
      home: mainScreen,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        AppRoutes.home: (context) => mainScreen,
        AppRoutes.addCurrency: (context) => new AddCurrencyScreen()
      },
    );
  }

  _constructTheme() {
    final baseTheme = Theme.of(context);

    const baseFont = 'Tahoma';
    final baseTextStyle =
        TextStyle(color: AppTheme.accentColor, fontFamily: baseFont);

    final textTheme = baseTheme.textTheme.copyWith(
      display1: baseTextStyle.copyWith(),
      body1: baseTextStyle.copyWith(),
    );

    final iconTheme =
        baseTheme.primaryIconTheme.copyWith(color: AppTheme.accentColor);

    return new ThemeData(
      primarySwatch: AppTheme.primaryColor,
      iconTheme: iconTheme,
      hintColor: AppTheme.accentColor, // borders of textfield hints
      textTheme: textTheme,
    );
  }
}
