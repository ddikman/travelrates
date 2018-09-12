import 'package:moneyconverter/app_state.dart';
import 'package:moneyconverter/model/conversion_model.dart';
import 'package:moneyconverter/model/currency_rate.dart';
import 'package:moneyconverter/services/logger.dart';
import 'package:moneyconverter/services/state_persistence.dart';

import 'package:moneyconverter/model/currency.dart';
import 'package:flutter/material.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final AppState state;

  StateContainer({
    @required this.child,
    this.state,
  });

  static StateContainerState of(BuildContext context) {
    _InheritedStateContainer stateContainer =
        context.inheritFromWidgetOfExactType(_InheritedStateContainer);
    return stateContainer.data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  final _statePersistence = new StatePersistence();

  static final log = new Logger<StateContainerState>();

  AppState appState;

  @override
  void initState() {
    if (widget.state != null) {
      print("Loaded app with defined state.");
      appState = widget.state;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  void setAppState(AppState state) {
    setState(() {
      appState = state;
    });
  }

  void _updateAndPersist(AppState state) {
    setState(() {
      appState = state;
    });

    _statePersistence.store(appState);
  }

  void toggleEditing() {
    // update without persisting
    setState(() {
      appState =
          appState.isEditing ? appState.stopEdit() : appState.startEdit();
    });
  }

  void removeCurrency(String currencyCode) {
    final currencies = List<String>.from(appState.conversion.currencies);
    currencies.remove(currencyCode);
    _updateConversion(appState.conversion.withCurrencies(currencies));
  }

  void addCurrency(String currencyCode) {
    final currencies = List<String>.from(appState.conversion.currencies);
    currencies.add(currencyCode);
    _updateConversion(appState.conversion.withCurrencies(currencies));
  }

  void _updateConversion(ConversionModel conversion) {
    _updateAndPersist(appState.withConversion(conversion));
  }

  void setAmount(double amount, Currency currency) {
    _updateConversion(
        appState.conversion.withAmount(amount: amount, currency: currency));
  }

  void reorder({String item, String placeAfter}) {
    log.event("reordering $item to be after $placeAfter..");
    final currencies = List<String>.from(appState.conversion.currencies);
    currencies.remove(item);
    final newPosition = currencies.indexOf(placeAfter) + 1;
    currencies.insert(newPosition, item);
    _updateConversion(appState.conversion.withCurrencies(currencies));
  }

  void setRates(List<CurrencyRate> rates) {
    setState(() {
      this.appState.availableCurrencies.updateRates(rates);
    });
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
