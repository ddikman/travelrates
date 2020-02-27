import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/screens/convert/convert_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Can use convert dialog', (WidgetTester tester) async {
    double submittedValue;
    final onSubmitted = (val) => submittedValue = val;
    final convertDialog = new ConvertDialog(onSubmitted: onSubmitted, currencyCode: 'SEK');
    final appContainer = new MaterialApp(home: convertDialog);

    await tester.pumpWidget(appContainer);
    final inputFinder = find.byType(TextField);
    final convertButtonFinder = find.byType(FlatButton);
    expect(inputFinder, findsOneWidget);
    expect(convertButtonFinder, findsOneWidget);

    final TextField input = tester.widget(inputFinder);
    await tester.enterText(inputFinder, '1000000');
    await tester.pumpAndSettle();
    expect(input.controller.value.text, '1,000,000');

    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle();

    expect(submittedValue, 1000000);
  });

  testWidgets('Can convert with Swedish locality', (WidgetTester tester) async {
    double submittedValue;
    final onSubmitted = (val) => submittedValue = val;
    final convertDialog = new ConvertDialog(onSubmitted: onSubmitted, currencyCode: 'SEK');
    final appContainer = new MaterialApp(home: convertDialog);

    await tester.pumpWidget(appContainer);
    final inputFinder = find.byType(TextField);
    final convertButtonFinder = find.byType(FlatButton);
    expect(inputFinder, findsOneWidget);
    expect(convertButtonFinder, findsOneWidget);

    final TextField input = tester.widget(inputFinder);
    await Intl.withLocale('sv', () async {
      await tester.enterText(inputFinder, '10000');
      await tester.pumpAndSettle();
      expect(input.controller.value.text, '10 000');
    });

    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle();

    expect(submittedValue, 10000);
  });

  testWidgets('Does not trigger convert if no value is given', (WidgetTester tester) async {
    bool submitCalled = false;
    final onSubmitted = (str) => submitCalled = true;
    final convertDialog = new ConvertDialog(onSubmitted: onSubmitted, currencyCode: 'SEK');
    final appContainer = new MaterialApp(home: convertDialog);

    await tester.pumpWidget(appContainer);
    final convertButtonFinder = find.byType(FlatButton);
    await tester.tap(convertButtonFinder);
    await tester.pumpAndSettle();

    expect(submitCalled, false);
  });
}
