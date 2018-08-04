import 'package:backpacking_currency_converter/state_container.dart';
import 'package:flutter/material.dart';

class ToggleConfigureButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;
    IconData displayIcon = state.isEditing ? Icons.done : Icons.settings;

    return new IconButton(
        icon: Icon(displayIcon),
        onPressed: () {
          StateContainer.of(context).toggleEditing();
        });
  }
}
