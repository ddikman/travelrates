import 'package:flutter/services.dart';
import 'package:travelconverter/app_root.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/services/rates_loader.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'package:travelconverter/state_container.dart';

void main() {
  final ratesLoader = new RatesLoader();
  final state = new StatePersistence();
  state.load(ratesLoader, rootBundle).then((state) {
    final appRoot = new AppRoot();
    runApp(new StateContainer(child: appRoot, state: state));
  });
}
