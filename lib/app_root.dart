import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_core/theme/theme_colors.dart';
import 'package:travelconverter/l10n/localized_data.dart';
import 'package:travelconverter/l10n/localized_data_provider.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/routing/router.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/services/rates_api.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:travelconverter/state_container.dart';
import 'package:travelconverter/use_cases/dark_mode/state/theme_brightness_notifier_provider.dart';
import 'package:travelconverter/l10n/app_localizations.dart';

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
    return Consumer(builder: (context, ref, child) {
      final themeBrightnessSetting = ref.watch(themeBrightnessNotifierProvider);
      return new MaterialApp.router(
        routerConfig: router,
        theme: _constructTheme(lightTheme),
        darkTheme: _constructTheme(darkTheme),
        themeMode: themeBrightnessSetting,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: (context, child) {
          final locale = Localizations.localeOf(context);
          debugPrint("context: ${locale}");
          return LocalizedDataProvider(
            data: LocalizedData.withLocale(
              locale,
            ),
            child: child!,
          );
        },
      );
    });
  }

  _constructTheme(ThemeColors colorTheme) {
    final baseTheme = Theme.of(context);

    final textTheme = baseTheme.textTheme.apply(
      bodyColor: colorTheme.text,
    );

    final iconTheme =
        baseTheme.primaryIconTheme.copyWith(color: colorTheme.text);

    final bottomSheetTheme = baseTheme.bottomSheetTheme.copyWith(
        backgroundColor: colorTheme.background,
        elevation: 16,
        shadowColor: Colors.black);

    final textSelectionTheme = baseTheme.textSelectionTheme.copyWith(
      cursorColor: colorTheme.accent,
      selectionColor: colorTheme.accent30,
      selectionHandleColor: colorTheme.accent,
    );

    return new ThemeData(
        brightness: colorTheme.mode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
        textSelectionTheme: textSelectionTheme,
        iconTheme: iconTheme,
        textTheme: textTheme,
        bottomSheetTheme: bottomSheetTheme,
        scaffoldBackgroundColor: colorTheme.background,
        appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: colorTheme.background,
            foregroundColor: colorTheme.text));
  }

  void handleLoadedRates(List<CurrencyRate> rates) {
    StateContainer.of(context).setRates(rates);
  }
}
