import 'package:travelconverter/l10n/fallback_material_localisations_delegate.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/screens/add_currency/add_currency_screen.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/screens/convert/convert_screen.dart';
import 'package:travelconverter/l10n/app_localizations_delegate.dart';
import 'package:travelconverter/screens/edit_screen/edit_screen.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:travelconverter/state_container.dart';

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() {
    return new _AppRootState();
  }
}

class _AppRootState extends State<AppRoot> {

  static final log = new Logger<_AppRootState>();

  @override
  void initState() {
    super.initState();

    new RatesLoader().loadOnlineRates()
      .then(handleLoadedRates)
      .catchError((error) => {
        log.error("Failed to load online rates: $error")
      });
  }

  @override
  Widget build(BuildContext context) {
    var state = StateContainer.of(context).appState;
    var initialRoute = "/";
    if (state.conversion.currencies.isEmpty) {
      initialRoute = AppRoutes.addCurrency;
    }

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
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        AppRoutes.convert: (context) => new ConvertScreen(),
        AppRoutes.addCurrency: (context) => new AddCurrencyScreen(),
        AppRoutes.edit: (context) => new EditScreen()
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

  void handleLoadedRates(AsyncResult<List<CurrencyRate>> rates) {
    if (!rates.successful) {
      return;
    }

    StateContainer.of(context).setRates(rates.result);
    log.event("Online rates loaded");
  }
}
