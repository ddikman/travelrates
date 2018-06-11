import 'dart:async';

import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/currency_repository.dart';
import 'package:flutter/material.dart';

class AppState {
  final double currentAmount;

  final Currency currentCurrency;

  final bool isLoading;

  final CurrencyRepository currencyRepo;

  double getAmountInCurrency(Currency currency) {
    if (currency.code == currentCurrency.code) {
      return currentAmount;
    }

    return getAmountInBaseCurrency() * currency.rate;
  }

  double getAmountInBaseCurrency() {
    return currentAmount / currentCurrency.rate;
  }

  static AppState loading() => new AppState(
    currentAmount: 1.0,
    currentCurrency: null,
    isLoading: true,
    currencyRepo: null
  );

  const AppState({@required this.currentAmount, @required this.currentCurrency, @required this.isLoading, @required this.currencyRepo});

  AppState copyWith({double amount, Currency currency, bool isLoading}) {
    return new AppState(
      currentAmount: amount ?? this.currentAmount,
      currentCurrency: currency ?? this.currentCurrency,
      isLoading: isLoading ?? this.isLoading,
      currencyRepo: this.currencyRepo
    );
  }
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final AppState state;

  StateContainer({
    @required this.child,
    this.state,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
    as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  AppState appState;

  @override
  void initState() {
    appState = AppState.loading();
    super.initState();
  }

  @override
  Future<Null> didChangeDependencies() async {
    super.didChangeDependencies();

    if (widget.state != null) {
      appState = widget.state;
    } else if (appState.isLoading) {
      final currencyRepository = await CurrencyRepository.loadFrom(DefaultAssetBundle.of(context));
      final loadedState = new AppState(
        currentAmount: 1.0,
        currentCurrency: currencyRepository.getBaseRateCurrency(),
        isLoading: false,
        currencyRepo: currencyRepository
      );
      setState(() {
        appState = loadedState;
      });
    }
  }


  void update(AppState state) {
    setState(() {
      appState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  void setAmount(double amount, Currency currency) {
    update(appState.copyWith(
      amount: amount,
      currency: currency
    ));
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