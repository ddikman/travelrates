import 'package:backpacking_currency_converter/app_root.dart';
import 'package:flutter/material.dart';

import 'package:backpacking_currency_converter/state_container.dart';

void main() {
  runApp(
      new StateContainer(
          child: new AppRoot()
      )
  );
}

