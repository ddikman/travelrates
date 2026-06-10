import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconverter/use_cases/home/ui/custom_keyboard_sheet.dart';

void main() {
  // Taps a keypad button by its label, scoped to the keypad grid so it never
  // collides with the (formatted) value shown in the input field.
  Future<void> tapKey(WidgetTester tester, String label) async {
    await tester.tap(find.descendant(
        of: find.byType(GridView), matching: find.text(label)));
    await tester.pump();
  }

  Future<void> typeKeys(WidgetTester tester, String keys) async {
    for (final key in keys.split('')) {
      await tapKey(tester, key);
    }
  }

  String fieldText(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).controller!.text;

  // The keypad is designed for a phone-width bottom sheet; size the test view
  // accordingly so the square button grid fits without overflowing.
  void usePhoneSizedView(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  group('display formatting', () {
    Future<void> pumpSheet(WidgetTester tester) async {
      usePhoneSizedView(tester);
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CustomKeyboardSheet(currencyCode: 'USD', initialValue: 0),
        ),
      ));
    }

    testWidgets('groups large numbers with thousand separators',
        (tester) async {
      await pumpSheet(tester);

      await typeKeys(tester, '1000000');

      expect(fieldText(tester), '1,000,000');
    });

    testWidgets('groups the integer part while keeping decimals',
        (tester) async {
      await pumpSheet(tester);

      await typeKeys(tester, '1234.5');

      expect(fieldText(tester), '1,234.5');
    });

    testWidgets('groups each operand of an expression', (tester) async {
      await pumpSheet(tester);

      await typeKeys(tester, '1000+2000');

      expect(fieldText(tester), '1,000+2,000');
    });

    testWidgets('reformats after backspace', (tester) async {
      await pumpSheet(tester);

      await typeKeys(tester, '1000');
      expect(fieldText(tester), '1,000');

      await tester.tap(find.byIcon(Icons.backspace));
      await tester.pump();

      expect(fieldText(tester), '100');
    });
  });

  group('submit', () {
    // Pushes the sheet via go_router (it pops its result with context.pop) and
    // returns a holder whose value is set once the sheet is dismissed.
    Future<List<double?>> pumpSheetRoute(WidgetTester tester) async {
      usePhoneSizedView(tester);
      final popped = <double?>[null];
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    popped[0] = await context.push<double>('/sheet');
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/sheet',
            builder: (context, state) => const Scaffold(
              body: CustomKeyboardSheet(currencyCode: 'USD', initialValue: 0),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return popped;
    }

    testWidgets('returns a plain large value without separators',
        (tester) async {
      final popped = await pumpSheetRoute(tester);

      await typeKeys(tester, '1000000');
      await tapKey(tester, '=');
      await tester.pumpAndSettle();

      expect(popped[0], 1000000.0);
    });

    testWidgets('evaluates and returns an expression result', (tester) async {
      final popped = await pumpSheetRoute(tester);

      await typeKeys(tester, '1000+2000');
      await tapKey(tester, '=');
      await tester.pumpAndSettle();

      expect(popped[0], 3000.0);
    });
  });
}
