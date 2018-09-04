import 'package:moneyconverter/screens/app_root.dart';
import 'package:moneyconverter/state_container.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_app_state.dart';
import 'mocks/mocked_state_loader.dart';

void main() {
  testWidgets('Application main widget can be instantiated',
      (WidgetTester tester) async {

    final mockStateLoader = new MockedStateLoader(mockAppState());
    final appRoot = new AppRoot(stateLoader: mockStateLoader);

    await tester.pumpWidget(new StateContainer(child: appRoot));

    // allow the application to settle before we complete
    // if we don't do this we'll get an exception complaining that timers
    // haven't been disposed
    await tester.pumpAndSettle();
  });
}
