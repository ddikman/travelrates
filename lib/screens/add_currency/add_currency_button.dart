import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:flutter/material.dart';

class AddCurrencyButton extends StatelessWidget {

  final Currency currency;

  const AddCurrencyButton({Key key, this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alreadyAdded = StateContainer.of(context).appState
        .currencies.contains(currency.code);

    final disabledTransparency = alreadyAdded ? 0.5 : 1.0;

    return new GestureDetector(
      child: Icon(
        Icons.add_circle,
        size: 24.0,
        color: Color.fromRGBO(255, 255, 255, disabledTransparency),
      ),
      onTap: () => alreadyAdded ? _displayNotice(context) : _addCurrency(context),
    );
  }

  _displayNotice(BuildContext context) {
    print("${currency.name} already added, showing snack instead");

    final snackBar = new SnackBar(
        content: Text("${currency.name} is already selected!")
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  _addCurrency(BuildContext context) {
    final stateContainer = StateContainer.of(context);
    stateContainer.addCurrency(currency.code);

    // return to previous screen
    Navigator.of(context).pop();
  }
}