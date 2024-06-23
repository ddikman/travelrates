import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/l10n/fallback_material_localisations_delegate.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/routing/router.dart';
import 'package:travelconverter/l10n/app_localizations_delegate.dart';
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
    return new MaterialApp.router(
      routerConfig: router,
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
    );
  }

  _constructTheme() {
    final baseTheme = Theme.of(context);

    final baseTextStyle = TextStyle(
        color: lightTheme.text, fontFamily: ThemeTypography.fontFamily);

    final textTheme = baseTheme.textTheme.copyWith(
      headlineMedium: baseTextStyle.copyWith(),
      bodyMedium: baseTextStyle.copyWith(),
    );

    final iconTheme =
        baseTheme.primaryIconTheme.copyWith(color: lightTheme.text);

    final bottomSheetTheme = baseTheme.bottomSheetTheme.copyWith(
        backgroundColor: lightTheme.background,
        elevation: 16,
        shadowColor: Colors.black);

    final snackbarTheme = baseTheme.snackBarTheme.copyWith(
      backgroundColor: lightTheme.background,
      contentTextStyle: baseTextStyle.copyWith(color: lightTheme.text),
      actionTextColor: lightTheme.text,
      elevation: 2,
    );

    return new ThemeData(
        iconTheme: iconTheme,
        textTheme: textTheme,
        bottomSheetTheme: bottomSheetTheme,
        scaffoldBackgroundColor: lightTheme.background,
        snackBarTheme: snackbarTheme,
        appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: lightTheme.background,
            foregroundColor: lightTheme.text));
  }

  void handleLoadedRates(List<CurrencyRate> rates) {
    StateContainer.of(context).setRates(rates);
  }
}
