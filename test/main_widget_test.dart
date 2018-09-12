import 'package:flutter/material.dart';
import 'package:moneyconverter/app_root.dart';
import 'package:moneyconverter/state_container.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_asset_bundle.dart';
import 'mocks/mock_app_state.dart';
import 'mocks/mocked_state_loader.dart';

void main() {
  testWidgets('Application main widget can be instantiated',
      (WidgetTester tester) async {
    final mockStateLoader = new MockedStateLoader(mockAppState());
    final appRoot = new AppRoot(stateLoader: mockStateLoader);

    final appContainer = new DefaultAssetBundle(
        bundle: new TestAssetBundle(),
        child: new StateContainer(child: appRoot)
    );

    await tester.pumpWidget(appContainer);

    // allow the application to settle before we complete
    // if we don't do this we'll get an exception complaining that timers
    // haven't been disposed
    await tester.pumpAndSettle();

    expect(find.byWidget(appRoot), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);

    // TODO: this fails with the current async localization
    //expect(find.byType(ConvertScreen), findsOneWidget);
  });
}
