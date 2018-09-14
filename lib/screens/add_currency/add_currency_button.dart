import 'package:intl/intl.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/state_container.dart';
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

    final localizations = AppLocalizations.of(context);
    var currencyLocalizedName = localizations.currencies.getLocalized(currency.code);

    final snackBar = new SnackBar(
        content: Text(_alreadySelectedWarning(currencyLocalizedName))
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  int _currentNumberOfCurrencies(StateContainerState stateContainer) {
    return stateContainer.appState.conversion.currencies.length;
  }

  _addCurrency(BuildContext context) {
    final state = StateContainer.of(context);
    state.addCurrency(currency.code);

    // if it is the first currency we add, it should be the refence 1
    if (_currentNumberOfCurrencies(state) == 1) {
      state.setAmount(1.0, currency);
    }

    // return to previous screen
    Navigator.of(context).pop();
  }

  String _alreadySelectedWarning(String currencyName) {
    return Intl.message(
        "$currencyName is already selected!",
        name: "_alreadySelectedWarning",
        desc: "Text displayed when trying to add a currency that is already added.",
        args: [currencyName]
    );
  }
}