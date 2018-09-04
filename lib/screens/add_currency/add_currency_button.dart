import 'package:moneyconverter/model/currency.dart';
import 'package:moneyconverter/services/logger.dart';
import 'package:moneyconverter/state_container.dart';
import 'package:flutter/material.dart';

class AddCurrencyButton extends StatelessWidget {

  final Currency currency;

  static final log = new Logger<AddCurrencyButton>();

  const AddCurrencyButton({Key key, this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alreadyAdded = StateContainer.of(context).appState
        .conversion.currencies.contains(currency.code);

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
    log.event("${currency.name} already added, showing snack instead");

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