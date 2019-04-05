import 'package:travelconverter/app_root.dart';
import 'package:travelconverter/screens/add_currency/add_currency_screen.dart';
import 'package:travelconverter/screens/convert/convert_screen.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_app_state.dart';

void main() {
  testWidgets('When application starts, the add currency screen is displayed if no currencies are selected',
      (WidgetTester tester) async {

    final appRoot = new AppRoot();
    final state = mockAppState();
    state.conversion.currencies.clear();

    await tester.pumpWidget(new StateContainer(child: appRoot, state: state));

    // allow the application to settle before we complete
    // if we don't do this we'll get an exception complaining that timers
    // haven't been disposed
    await tester.pumpAndSettle();

    expect(find.byType(AddCurrencyScreen), findsOneWidget);
  });

  testWidgets('When application starts, the conversion screen is displayed',
          (WidgetTester tester) async {

      final appRoot = new AppRoot();
      final state = mockAppState();

      await tester.pumpWidget(new StateContainer(child: appRoot, state: state));

      // allow the application to settle before we complete
      // if we don't do this we'll get an exception complaining that timers
      // haven't been disposed
      await tester.pumpAndSettle();

      expect(find.byType(ConvertScreen), findsOneWidget);
    });
}
