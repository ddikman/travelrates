
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/app_root.dart';
import 'package:travelconverter/duplicate_currency_error.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/services/state_persistence.dart';
import 'package:travelconverter/state_container.dart';

import 'mocks/mock_app_state.dart';
import 'mocks/mock_currency.dart';
import 'mocks/mock_local_storage.dart';

void main() {
  var appRoot = new AppRoot();
  final statePersistence = new StatePersistence(localStorage: new MockLocalStorage());
  var state = mockAppState();
  state = state.withConversion(new ConversionModel(
      currencies: [ "USD", "EUR" ],
      currentAmount: 1.0,
      currentCurrency: MockCurrency.dollar
  ));
  final stateContainerWidget = StateContainer(child: appRoot, state: state, statePersistence: statePersistence);

  testWidgets("sets first currency to one", (WidgetTester tester) async {

      final widget = new StateContainer(child: appRoot, state: mockAppState(), statePersistence: statePersistence);
      await tester.pumpWidget(widget);
      var stateContainer = tester.state<StateContainerState>(find.byType(StateContainer));

      expect(stateContainer.appState.conversion.currencies.length, 0);

      stateContainer.addCurrency("GBP");

      final conversion = stateContainer.appState.conversion;
      expect(conversion.currentCurrency.code, "GBP");
      expect(conversion.currentAmount, 1.0);
      expect(conversion.currencies.length, 1);
  });

  testWidgets("throws exception if trying to add a currency twice", (WidgetTester tester) async {
    await tester.pumpWidget(stateContainerWidget);

    var stateContainer = tester.state<StateContainerState>(find.byType(StateContainer));

    expect(() {
      stateContainer.addCurrency("USD");
    }, throwsA(isInstanceOf<DuplicateCurrencyError>()));
  });

  testWidgets("updates currencies with new reorder", (WidgetTester tester) async {
    await tester.pumpWidget(stateContainerWidget);

    var stateContainer = tester.state<StateContainerState>(find.byType(StateContainer));

    // if adding at top
    stateContainer.reorderCurrency(item: "EUR", newIndex: 0);
    expect(stateContainer.appState.conversion.currencies, [ "EUR", "USD" ]);

    // falls back to adding at the bottom if index is below bottom
    // this can happen when trying to move the first item after the last item
    stateContainer.reorderCurrency(item: "EUR", newIndex: 2);
    expect(stateContainer.appState.conversion.currencies, [ "USD", "EUR" ]);
  });

  testWidgets("updates rates", (WidgetTester tester) async {
    await tester.pumpWidget(stateContainerWidget);

    var stateContainer = tester.state<StateContainerState>(find.byType(StateContainer));
    stateContainer.setRates([
      new CurrencyRate("USD", 2.0),
      new CurrencyRate("EUR", 3.0),
    ]);

    expect(stateContainer.appState.availableCurrencies.getByCode("EUR").rate, 3.0);
    expect(stateContainer.appState.availableCurrencies.getByCode("USD").rate, 2.0);
  });

  testWidgets("removes currencies", (WidgetTester tester) async {
    await tester.pumpWidget(stateContainerWidget);

    var stateContainer = tester.state<StateContainerState>(find.byType(StateContainer));
    stateContainer.removeCurrency("USD");

    expect(stateContainer.appState.conversion.currencies, [ "EUR" ]);
  });
}