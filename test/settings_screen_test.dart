import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/settings/greycastle_copyright.dart';
import 'package:travelconverter/screens/settings/settings_screen.dart';

void main() {
  testWidgets('can show widget', (WidgetTester tester) async {
    await setupScreen(tester);

    expect(find.byType(GreycastleCopyright), findsOneWidget);
  });

  testWidgets('can trigger email', (WidgetTester tester) async {
    await setupScreen(tester);

    await tester.tap(find.text('CONTACT ME'));
    tester.pumpAndSettle();
  });
}

Future setupScreen(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: SettingsScreen(),
  ));
}