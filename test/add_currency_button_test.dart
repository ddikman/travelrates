import 'package:flutter/material.dart';
import 'package:moneyconverter/screens/add_currency/add_currency_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneyconverter/state_container.dart';

import 'helpers/mock_widget_frame.dart';
import 'mocks/mock_app_state.dart';
import 'mocks/mock_currency.dart';

void main() {
  testWidgets(
      "When adding first currency, it is set as the current currency with a one as reference",
      (WidgetTester tester) async {

        final dollar = MockCurrency.dollar;
        final widgetFrame = new MockWidgetFrame(
            child: new AddCurrencyButton(currency: dollar)
        );

        await tester.pumpWidget(widgetFrame);
        await tester.pumpAndSettle();

        // Then press to add
        await tester.tap(find.byType(Icon));
        await tester.pumpAndSettle();

        var stateContainer = tester.firstState(find.byType(StateContainer)) as StateContainerState;
        var appState = stateContainer.appState;

        // Then we should've changed current amount to one and currency to dollar
        expect(appState.conversion.currencies, ['USD']);
        expect(appState.conversion.currentCurrency, dollar);
        expect(appState.conversion.currentAmount, 1.0);
  });

  testWidgets('When adding a currency already added, displays warning', (WidgetTester tester) async {
        final dollar = MockCurrency.dollar;
        final appState = mockAppState();
        appState.conversion.currencies.add(dollar.code);
        final widgetFrame = new MockWidgetFrame(
            appState: appState,
            child: new Scaffold(
              body: new AddCurrencyButton(currency: dollar),
            )
        );

        await tester.pumpWidget(widgetFrame);
        await tester.pumpAndSettle();

        // Then press to add
        await tester.tap(find.byType(Icon));
        await tester.pumpAndSettle();

        // Then we expect to get a snackbar showing a warning
        expect(find.text('US Dollar is already selected!'), findsOneWidget);
  });
}
