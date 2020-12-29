import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/settings/contact_button.dart';
import 'package:travelconverter/screens/settings/greycastle_copyright.dart';
import 'package:travelconverter/screens/settings/settings_screen.dart';

void main() {
  testWidgets('can render screen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SettingsScreen(),
    ));

    expect(find.byType(GreycastleCopyright), findsOneWidget);
    expect(find.byType(ContactButton), findsOneWidget);
  });
}