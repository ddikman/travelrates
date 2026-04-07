import 'package:flutter/material.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/services/state_persistence.dart';
import 'package:travelconverter/state_container.dart';
import 'package:travelconverter/l10n/app_localizations.dart';

import '../mocks/mock_app_state.dart';
import '../mocks/mock_local_storage.dart';

class MockWidgetFrame extends StatefulWidget {
  final Widget _child;

  final AppState? appState;

  const MockWidgetFrame({super.key, required Widget child, this.appState}) : _child = child;

  @override
  State<MockWidgetFrame> createState() {
    return _MockWidgetFrameState();
  }
}

class _MockWidgetFrameState extends State<MockWidgetFrame> {
  final statePersistence =
      StatePersistence(localStorage: MockLocalStorage());

  @override
  Widget build(BuildContext context) {
    return StateContainer(
        statePersistence: statePersistence,
        state: widget.appState ?? mockAppState(),
        child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(builder: (BuildContext context) {
              return widget._child;
            })));
  }
}
