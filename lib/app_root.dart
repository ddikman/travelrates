import 'package:travelconverter/l10n/fallback_material_localisations_delegate.dart';
import 'package:travelconverter/screens/add_currency/add_currency_screen.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/screens/convert/convert_screen.dart';
import 'package:travelconverter/l10n/app_localizations_delegate.dart';
import 'package:travelconverter/screens/loader/state_loader_screen.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/services/state_loader.dart';
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

  static final log = new Logger<_AppRootState>();

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
      debugShowCheckedModeBanner: false,
      home: new StateLoaderScreen(stateLoader: widget.stateLoader),
      routes: <String, WidgetBuilder>{
        AppRoutes.convert: (context) => new ConvertScreen(),
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
