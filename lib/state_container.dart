import 'dart:async';

import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/currency_repository.dart';
import 'package:flutter/material.dart';

class AppState {
  final double currentAmount;

  final Currency currentCurrency;

  final bool isLoading;

  final CurrencyRepository currencyRepo;

  final List<String> currencies;

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
    currencyRepo: null,
    currencies: null
  );

  const AppState({@required this.currentAmount, @required this.currentCurrency, @required this.isLoading, @required this.currencyRepo, this.currencies});

  AppState copyWith({double amount, Currency currency, bool isLoading, List<String> currencies}) {
    return new AppState(
      currentAmount: amount ?? this.currentAmount,
      currentCurrency: currency ?? this.currentCurrency,
      isLoading: isLoading ?? this.isLoading,
      currencyRepo: this.currencyRepo,
      currencies: currencies ?? this.currencies
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

      final defaultCurrencies = <String>['JPY', 'SEK', 'USD', 'EUR', 'PHP', 'IDR'];

      final loadedState = new AppState(
        currentAmount: 1.0,
        currentCurrency: currencyRepository.getBaseRateCurrency(),
        isLoading: false,
        currencyRepo: currencyRepository,
        currencies: new List.from(defaultCurrencies)
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

  void removeCurrency(String currencyCode) {
    setState((){
      appState.currencies.remove(currencyCode);
    });
  }

  void addCurrency(String currencyCode) {
    setState((){
      appState.currencies.add(currencyCode);
    });
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