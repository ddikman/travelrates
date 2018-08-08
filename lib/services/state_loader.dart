import 'dart:async';

import 'package:flutter/widgets.dart';

/// Binds together the logic of loading the app state
abstract class StateLoader {

  Future load(BuildContext context);
}