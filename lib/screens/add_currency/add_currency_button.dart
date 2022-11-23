import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';

class AddCurrencyButton extends StatelessWidget {
  final Currency currency;

  const AddCurrencyButton({Key? key, required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alreadyAdded = StateContainer.of(context)
        .appState
        .conversion
        .currencies
        .contains(currency.code);
    final disabledTransparency = alreadyAdded ? 0.5 : 1.0;

    return new Icon(
      Icons.add_circle,
      size: 32.0,
      color: Color.fromRGBO(255, 255, 255, disabledTransparency),
    );
  }
}
