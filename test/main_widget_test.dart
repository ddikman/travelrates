import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/use_cases/home/ui/home_screen.dart';

import 'mocks/mock_app_container_builder.dart';
import 'mocks/mock_currency.dart';

void main() {
  testWidgets('When application starts, the conversion screen is displayed',
      (WidgetTester tester) async {
    final mainScreen = MainScreen();

    final appRoot = MockAppContainerBuilder(mainScreen)
        .withCurrentCurrency(MockCurrency.dollar)
        .withCurrentValue(1.0);

    await tester.pumpWidget(await appRoot.build());
    await tester.pumpAndSettle();

    expect(find.byType(MainScreen), findsOneWidget);
  });
}
