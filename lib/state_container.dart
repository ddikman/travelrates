import 'dart:async';

import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/model/currency_rate.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/services/state_persistence.dart';

import 'package:travelconverter/model/currency.dart';
import 'package:flutter/material.dart';

import 'duplicate_currency_error.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final AppState state;
  final StatePersistence statePersistence;

  StateContainer({
    @required this.child,
    this.state,
    this.statePersistence
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

  static final log = new Logger<StateContainerState>();

  StreamController<ConversionModel> _conversionUpdated = new StreamController<ConversionModel>();

  AppState appState;

  Stream<ConversionModel> get conversionUpdated => _conversionUpdated.stream;

  @override
  void initState() {
    if (widget.state != null) {
      print("Loaded app with defined state.");
      appState = widget.state;
    }

    super.initState();
  }

  @override
  void dispose() {
    _conversionUpdated.close();
    super.dispose();
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

    widget.statePersistence.store(appState);
  }

  void removeCurrency(String currencyCode) {
    final currencies = List<String>.from(appState.conversion.currencies);
    currencies.remove(currencyCode);
    _updateConversion(appState.conversion.withCurrencies(currencies));
  }

  void addCurrency(String currencyCode) {
    final currencies = List<String>.from(appState.conversion.currencies);
    if (currencies.contains(currencyCode)) {
      throw new DuplicateCurrencyError("Currency '$currencyCode' has already been added");
    }
    currencies.add(currencyCode);

    var conversion = appState.conversion.withCurrencies(currencies);
    if (conversion.currencies.length == 1) {
      final currency = appState.availableCurrencies.getByCode(currencyCode);
      conversion = conversion.withAmount(amount: 1.0, currency: currency);
    }
    _updateConversion(conversion);
  }

  void _updateConversion(ConversionModel conversion) {
    _updateAndPersist(appState.withConversion(conversion));
  }

  void setAmount(double amount, Currency currency) {
    var conversion = appState.conversion.withAmount(amount: amount, currency: currency);
    _updateConversion(conversion);
    _conversionUpdated.add(conversion);
  }

  void setRates(List<CurrencyRate> rates) {
    setState(() {
      this.appState.availableCurrencies.updateRates(rates);
    });
  }

  /// Reorder a currency in the list, newPosition beign the new index, zero-based.
  void reorderCurrency({String item, int newIndex}) {
    log.event("reordering $item to be at index $newIndex..");
    final currencies = List<String>.from(appState.conversion.currencies);
    currencies.remove(item);

    if (newIndex > currencies.length) {
      // insert at bottom
      currencies.add(item);
    } else {
      currencies.insert(newIndex, item);
    }
    _updateConversion(appState.conversion.withCurrencies(currencies));
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
