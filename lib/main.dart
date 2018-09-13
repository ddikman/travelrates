import 'package:moneyconverter/app_root.dart';
import 'package:moneyconverter/services/persisted_state_loader.dart';
import 'package:flutter/material.dart';

import 'package:moneyconverter/state_container.dart';

void main() {
  final appRoot = new AppRoot(stateLoader: new PersistedStateLoader());

  runApp(new StateContainer(child: appRoot));
}
