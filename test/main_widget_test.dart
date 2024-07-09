import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_root.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/async_result.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/use_cases/home/ui/home_screen.dart';

import 'mocks/mock_app_state.dart';
import 'mocks/mock_rates_api.dart';
import 'mocks/mock_state_persistence.dart';

void main() {
  testWidgets('When application starts, the conversion screen is displayed',
      (WidgetTester tester) async {
    final ratesApi = MockRatesApi();
    ratesApi.result = AsyncResult.failed();
    final state = mockAppState();

    await tester.pumpWidget(StateContainer(
        child: Builder(
          builder: (ctx) => ProviderScope(overrides: [
            appStateProvider.overrideWithValue(StateContainer.of(ctx).appState)
          ], child: AppRoot(ratesApi: ratesApi)),
        ),
        state: state,
        statePersistence: MockStatePersistence()));
    await tester.pumpAndSettle();

    expect(find.byType(MainScreen), findsOneWidget);
  });
}
