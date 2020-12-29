import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/settings/contact_button.dart';

void main() {
  testWidgets('can trigger email to be sent', (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr, child: ContactButton()));

    await tester.tap(find.text('CONTACT ME'));
    await tester.pumpAndSettle();
  });
}
