import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/l10n/app_localizations_delegate.dart';
import 'package:travelconverter/l10n/fallback_material_localisations_delegate.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/state_container.dart';

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

    final stateContainer = StateContainer(child: _child, state: appState);
    return new MaterialApp(home: stateContainer, localizationsDelegates: [
      const AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      const FallbackMaterialLocalisationsDelegate()
    ]);
  }

  /// Can be used to wrap entire test setup instead of just build()
  Future run(WidgetTester tester, Function testCode) async {

    await tester.pumpWidget(await this.build());
    await tester.pumpAndSettle();
    await testCode();
    await tester.pumpAndSettle();
  }
}
