import 'package:backpacking_currency_converter/screens/app_root.dart';
import 'package:backpacking_currency_converter/services/persisted_state_loader.dart';
import 'package:flutter/material.dart';

import 'package:backpacking_currency_converter/state_container.dart';

void main() {
  final appRoot = new AppRoot(stateLoader: new PersistedStateLoader());

  runApp(new StateContainer(child: appRoot));
}
