import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/review_feature/review_rule.dart';
import 'package:travelconverter/screens/review_feature/review_storage.dart';
import 'package:travelconverter/screens/review_feature/review_widget.dart';
import 'package:travelconverter/state_container.dart';

import 'helpers/mock_widget_frame.dart';
import 'mocks/mock_app_state.dart';
import 'mocks/mock_currency.dart';
import 'mocks/mock_internet_connectivity.dart';
import 'mocks/mock_local_storage.dart';

void main() {
  testWidgets(
      'Displays review snackbar a second after the nth review has been shown',
      (WidgetTester tester) async {
    final localStorage = MockLocalStorage();
    final reviewStorage = new ReviewStorage(
        new MockInternetConnectivity(), localStorage);
    final reviews = new ReviewRule(
        conversionsRequired: 5,
        conversionsDone: 4,
        submitted: false
    );
    reviewStorage.save(reviews);
    final state = mockAppState();
    final widgetFrame = MockWidgetFrame(
        appState: state,
        child: Scaffold(
          body: ReviewWidget(
            child: Text('Test'),
            reviewStorage: reviewStorage,
            toastDelay: Duration(seconds: 0),
          ),
        ));

    await tester.pumpWidget(widgetFrame);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      // do a conversion
      var stateContainer = tester.state<StateContainerState>(
          find.byType(StateContainer));
      stateContainer.setAmount(1.0, MockCurrency.dollar);
    });

    await tester.pumpAndSettle();

    // within two seconds, expect to find the snackbar
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
