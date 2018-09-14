import 'package:travelconverter/screens/add_currency/add_currency_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/add_currency/available_currency_card.dart';

import 'helpers/mock_widget_frame.dart';

void main() {
  testWidgets('When screen is shown, all available currencies are displayed',
      (WidgetTester tester) async {

    final widgetFrame = new MockWidgetFrame(
        child: new AddCurrencyScreen()
    );

    await tester.pumpWidget(widgetFrame);
    await tester.pumpAndSettle();

    expect(find.byType(AvailableCurrencyCard), findsNWidgets(3));
  });
}
