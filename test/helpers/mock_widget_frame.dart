import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/l10n/app_localizations_delegate.dart';
import 'package:travelconverter/l10n/fallback_material_localisations_delegate.dart';
import 'package:travelconverter/services/state_persistence.dart';
import 'package:travelconverter/state_container.dart';

import '../mocks/mock_app_state.dart';
import '../mocks/mock_local_storage.dart';

class MockWidgetFrame extends StatefulWidget {
  final Widget _child;

  final AppState? appState;

  MockWidgetFrame({required Widget child, this.appState}) : this._child = child;

  @override
  _MockWidgetFrameState createState() {
    return new _MockWidgetFrameState();
  }
}

class _MockWidgetFrameState extends State<MockWidgetFrame> {
  final statePersistence =
      new StatePersistence(localStorage: new MockLocalStorage());

  @override
  Widget build(BuildContext context) {
    return new StateContainer(
        statePersistence: statePersistence,
        state: widget.appState ?? mockAppState(),
        child: MaterialApp(
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              const FallbackMaterialLocalisationsDelegate()
            ],
            supportedLocales: AppLocalizationsDelegate.supportedLocales,
            home: new Builder(builder: (BuildContext context) {
              return widget._child;
            })));
  }
}
