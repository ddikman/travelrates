import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelconverter/l10n/fallback_material_localisations_delegate.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/screens/add_currency/add_currency_screen.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/screens/convert/convert_screen.dart';
import 'package:travelconverter/l10n/app_localizations_delegate.dart';
import 'package:travelconverter/screens/edit_screen/edit_screen.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:travelconverter/services/rates_api.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:travelconverter/state_container.dart';

class AppRoot extends StatefulWidget {
  final RatesApi ratesApi;

  const AppRoot({Key? key, required this.ratesApi}) : super(key: key);

  @override
  _AppRootState createState() {
    return new _AppRootState();
  }
}

class _AppRootState extends State<AppRoot> {
  static final log = new Logger<_AppRootState>();

  FirebaseAnalytics? _firebaseAnalytics;

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().then((app) {
      _firebaseAnalytics = FirebaseAnalytics.instanceFor(app: app);
      _firebaseAnalytics?.logAppOpen();
      Logger.analytics = _firebaseAnalytics;

      new RatesLoader(
              localStorage: new LocalStorage(), ratesApi: widget.ratesApi)
          .loadOnlineRates()
          .then(handleLoadedRates)
          .catchError(
              (error) => {log.error("Failed to load online rates: $error")});
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
      navigatorObservers: _firebaseAnalytics != null
          ? [FirebaseAnalyticsObserver(analytics: _firebaseAnalytics!)]
          : [],
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
      headline4: baseTextStyle.copyWith(),
      bodyText2: baseTextStyle.copyWith(),
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

  void handleLoadedRates(List<CurrencyRate> rates) {
    StateContainer.of(context).setRates(rates);
  }
}
