import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/convert/add_currency_handler.dart';
import 'package:travelconverter/state_container.dart';

import 'helpers/mock_widget_frame.dart';
import 'mocks/mock_app_state.dart';
import 'mocks/mock_currency.dart';

void main() {
  testWidgets("can add a new currency", (WidgetTester tester) async {

      final dollar = MockCurrency.dollar;
      final widgetFrame = new MockWidgetFrame(
          child: new Builder(builder: (BuildContext context) {
            final addHandler = new AddCurrencyHandler(dollar);
            return FlatButton(
              child: Text("Button"),
              onPressed: () => addHandler.addCurrency(context),
            );
          })
      );

      await tester.pumpWidget(widgetFrame);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FlatButton));
      await tester.pumpAndSettle();

      var stateContainer = tester.firstState(find.byType(StateContainer)) as StateContainerState;
      var appState = stateContainer.appState;

      // Then we should've changed current amount to one and currency to dollar
      expect(appState.conversion.currencies, ['USD']);
      expect(appState.conversion.currentCurrency, dollar);
      expect(appState.conversion.currentAmount, 1.0);
  });

  testWidgets("shows snackbar if currency is already added", (WidgetTester tester) async {
    var initialAppState = mockAppState();
    initialAppState = initialAppState.withConversion(initialAppState.conversion.withCurrencies(["USD"]));

    final dollar = MockCurrency.dollar;
    final widgetFrame = new MockWidgetFrame(
      appState: initialAppState,
        child: Scaffold(
          body: new Builder(builder: (BuildContext context) {
            final addHandler = new AddCurrencyHandler(dollar);
            return FlatButton(
              child: Text("Button"),
              onPressed: () => addHandler.addCurrency(context),
            );
          }),
        )
    );

    await tester.pumpWidget(widgetFrame);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FlatButton));
    await tester.pump(Duration.zero);

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('US Dollar is already selected!'), findsOneWidget);

    var stateContainer = tester.firstState(
        find.byType(StateContainer)) as StateContainerState;
    var appState = stateContainer.appState;
    expect(appState.conversion.currencies, ["USD"]);
  });
}