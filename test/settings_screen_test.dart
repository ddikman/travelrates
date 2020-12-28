import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/settings/greycastle_copyright.dart';
import 'package:travelconverter/screens/settings/settings_screen.dart';

void main() {
  testWidgets('Can show widgets', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SettingsScreen(),
    ));

    expect(find.byType(GreycastleCopyright), findsOneWidget);
  });
}