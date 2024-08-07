import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/use_cases/home/ui/compare_currency_card.dart';

import '../../../mocks/mock_app_container_builder.dart';
import '../../../mocks/mock_currency.dart';

void main() {
  Future whenCurrentValueIs(
      double currentValue, Function testCode, WidgetTester tester) async {
    final currencyCard = new CompareCurrencyCard(currency: MockCurrency.dollar);

    final appRoot = new MockAppContainerBuilder(currencyCard)
        .withCurrentCurrency(MockCurrency.dollar)
        .withCurrentValue(currentValue);

    await appRoot.run(tester, testCode);
  }

  thenDisplayedValueIs(String expectedValue, WidgetTester tester) {
    final value = find.byKey(Key('ValueDisplay'));
    expect(value, findsOneWidget);

    final Text text = tester.widget(value);
    expect(text.data, expectedValue);
  }

  testWidgets('Displays current value', (WidgetTester tester) async {
    await whenCurrentValueIs(2.0, () {
      thenDisplayedValueIs('2', tester);
    }, tester);
  });

  testWidgets('Rounds off and formats current value',
      (WidgetTester tester) async {
    await whenCurrentValueIs(2333333.333, () {
      thenDisplayedValueIs('2,333,300', tester);
    }, tester);
  });

  testWidgets('Rounds up to two decimals for smaller values',
      (WidgetTester tester) async {
    await whenCurrentValueIs(4.333, () {
      thenDisplayedValueIs('4.33', tester);
    }, tester);
  });
}
