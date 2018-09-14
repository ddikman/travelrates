import 'package:travelconverter/app_root.dart';
import 'package:travelconverter/services/persisted_state_loader.dart';
import 'package:flutter/material.dart';

import 'package:travelconverter/state_container.dart';

void main() {
  final appRoot = new AppRoot(stateLoader: new PersistedStateLoader());

  runApp(new StateContainer(child: appRoot));
}
