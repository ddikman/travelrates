
import 'dart:async';

import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/services/state_loader.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MockedStateLoader implements StateLoader {

  final AppState initialState;

  MockedStateLoader(this.initialState);

  @override
  Future load(BuildContext context) async {
    final stateContainer = StateContainer.of(context);
    stateContainer.setAppState(initialState);
  }
}