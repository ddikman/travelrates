import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/l10n/localized_data.dart';
import 'package:travelconverter/l10n/localized_data_provider.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/services/state_persistence.dart';
import 'package:travelconverter/state_container.dart';
import 'package:travelconverter/l10n/app_localizations.dart';

import 'mock_country.dart';
import 'mock_currency.dart';
import 'mock_currency_repository.dart';
import 'mock_local_storage.dart';

class MockAppContainerBuilder {
  Currency _currentCurrency = MockCurrency.dollar;
  double _currentValue = 1.0;
  final Widget _child;

  MockAppContainerBuilder(this._child);

  MockAppContainerBuilder withCurrentCurrency(Currency currency) {
    _currentCurrency = currency;
    return this;
  }

  MockAppContainerBuilder withCurrentValue(double value) {
    _currentValue = value;
    return this;
  }

  /// Builds the app root widget with material app, localization and state
  Future<Widget> build() async {
    final appState = AppState.initial(
            availableCurrencies: mockCurrencyRepository(),
            countries: MockCountry.all)
        .withConversion(ConversionModel(
            currentAmount: _currentValue,
            currentCurrency: _currentCurrency,
            currencies: ['GBP', 'USD', 'EUR']));

    final statePersistence =
        StatePersistence(localStorage: MockLocalStorage());

    return MaterialApp(
      home: StateContainer(
        state: appState,
        statePersistence: statePersistence,
        child: Builder(
          builder: (ctx) => ProviderScope(
            overrides: [
              appStateProvider.overrideWithValue(appState),
            ],
            child: LocalizedDataProvider(
              data: LocalizedData.withLocale(const Locale('en')),
              child: _child,
            ),
          ),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  /// Can be used to wrap entire test setup instead of just build()
  Future run(WidgetTester tester, Function testCode) async {
    await tester.pumpWidget(await build());
    await tester.pumpAndSettle();
    await testCode();
    await tester.pumpAndSettle();
  }
}
