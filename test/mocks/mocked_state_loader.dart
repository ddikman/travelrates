
import 'dart:async';

import 'package:backpacking_currency_converter/app_state.dart';
import 'package:backpacking_currency_converter/services/state_loader.dart';
import 'package:backpacking_currency_converter/state_container.dart';
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