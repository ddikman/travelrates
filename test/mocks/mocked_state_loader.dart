
import 'dart:async';

import 'package:moneyconverter/app_state.dart';
import 'package:moneyconverter/services/state_loader.dart';
import 'package:moneyconverter/state_container.dart';
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