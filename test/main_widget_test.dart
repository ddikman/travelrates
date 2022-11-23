import 'package:travelconverter/app_root.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/screens/add_currency/add_currency_screen.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_app_state.dart';
import 'mocks/mock_rates_api.dart';
import 'mocks/mock_state_persistence.dart';

void main() {
  testWidgets(
      'When application starts, the add currency screen is displayed if no currencies are selected',
      (WidgetTester tester) async {
    final appRoot = AppRoot(ratesApi: MockRatesApi());
    final state = mockAppState();
    state.conversion.currencies.clear();

    await tester.pumpWidget(new StateContainer(
        child: appRoot,
        state: state,
        statePersistence: MockStatePersistence()));

    // allow the application to settle before we complete
    // if we don't do this we'll get an exception complaining that timers
    // haven't been disposed
    await tester.pumpAndSettle();

    expect(find.byType(AddCurrencyScreen), findsOneWidget);
  });

  testWidgets('When application starts, the conversion screen is displayed',
      (WidgetTester tester) async {
    final ratesApi = MockRatesApi();
    ratesApi.result = AsyncResult.failed();
    final appRoot = new AppRoot(ratesApi: ratesApi);
    final state = mockAppState();

    await tester.pumpWidget(new StateContainer(
        child: appRoot,
        state: state,
        statePersistence: MockStatePersistence()));
    await tester.pumpAndSettle();

    expect(find.byType(AddCurrencyScreen), findsOneWidget);
  });
}
