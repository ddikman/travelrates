import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'mock_country.dart';
import 'mock_currency.dart';
import 'mock_currency_repository.dart';

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
        .withConversion(new ConversionModel(
            currentAmount: _currentValue,
            currentCurrency: _currentCurrency,
            currencies: ['GBP', 'USD', 'EUR']));

    return new MaterialApp(
      home: ProviderScope(
        overrides: [
          appStateProvider.overrideWithValue(appState),
        ],
        child: _child,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  /// Can be used to wrap entire test setup instead of just build()
  Future run(WidgetTester tester, Function testCode) async {
    await tester.pumpWidget(await this.build());
    await tester.pumpAndSettle();
    await testCode();
    await tester.pumpAndSettle();
  }
}
