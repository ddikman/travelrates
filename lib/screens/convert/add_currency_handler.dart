import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/state_container.dart';

class AddCurrencyHandler {

  static final log = new Logger<AddCurrencyHandler>();

  final Currency currency;

  AddCurrencyHandler(this.currency);

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

  addCurrency(BuildContext context) {
    try {
      final state = StateContainer.of(context);
      state.addCurrency(currency.code);

      // if it is the first currency we add, it should be the refence 1
      if (_currentNumberOfCurrencies(state) == 1) {
        state.setAmount(1.0, currency);
      }

      // return to previous screen
      Navigator.of(context).pop();
    } catch(DuplicateCurrencyError) {
      _displayNotice(context);
    }
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