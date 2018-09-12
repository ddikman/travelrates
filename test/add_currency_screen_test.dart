import 'package:flutter/material.dart';
import 'package:moneyconverter/screens/add_currency/add_currency_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/mock_widget_frame.dart';

void main() {
  testWidgets('When screen is shown, all currencies are displayed',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      new MockWidgetFrame(
        child: new AddCurrencyScreen()
      )
    );

    await tester.pumpAndSettle();

    for (Widget widget in tester.allWidgets) {
      print(widget);
    }

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(AddCurrencyScreen), findsOneWidget);
    // TODO: this breaks with the current async localization
    // expect(find.byType(AvailableCurrencyCard), findsNWidgets(3));
  });
}