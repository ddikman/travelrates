import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:backpacking_currency_converter/model/country.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/services/currency_repository.dart';
import 'package:flutter/material.dart';

class AppState {
  final double currentAmount;

  final Currency currentCurrency;

  // TODO: this could have a better name
  final bool isReconfiguring;

  final CurrencyRepository currencyRepo;

  final List<String> currencies;

  final List<Country> countries;

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
      currencyRepo: null,
      currencies: null,
      isReconfiguring: false);

  const AppState(
      {@required this.currentAmount,
      @required this.currentCurrency,
      @required this.currencyRepo,
      this.currencies,
      this.isReconfiguring = false,
      this.countries});

  AppState copyWith(
      {double amount,
      Currency currency,
      List<String> currencies,
      bool isReconfiguring,
      List<Country> countries}) {
    return new AppState(
        currentAmount: amount ?? this.currentAmount,
        currentCurrency: currency ?? this.currentCurrency,
        currencyRepo: this.currencyRepo,
        currencies: currencies ?? this.currencies,
        isReconfiguring: isReconfiguring ?? this.isReconfiguring,
        countries: countries ?? this.countries);
  }

  Map<String, dynamic> toJson() => {
        'currentAmount': currentAmount,
        'currentCurrency': currentCurrency.code,
        'currencies': currencies
      };

  AppState.fromJson(Map<String, dynamic> json, CurrencyRepository repository,
      List<Country> countries)
      : this.currencyRepo = repository,
        this.isReconfiguring = false,
        this.currencies = List.castFrom(json['currencies']),
        this.currentCurrency =
            repository.getCurrencyByCode(json['currentCurrency']),
        this.currentAmount = json['currentAmount'],
        this.countries = countries;
}

class
StateContainer extends StatefulWidget {
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

  Future<bool> get _persistedStateExists async {
    final stateFile = await _localFile;
    return await stateFile.exists();
  }

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
    } else {
      appState = AppState.loading();
    }
  }

  bool get isStateLoaded => appState.countries != null && appState.countries.isNotEmpty;

  Future<Null> loadState() async {
    print('loading currency rates from disk..');
    final currencyRepository =
        await CurrencyRepository.loadFrom(DefaultAssetBundle.of(context));

    final countries = await _loadCountries(DefaultAssetBundle.of(context));
    countries.sort((countryA, countryB) {
      return countryA.name.toLowerCase().compareTo(countryB.name.toLowerCase());
    });

    if (await _persistedStateExists) {
      print('found persisted state, loading that..');
      final persistedState = await _loadState(currencyRepository, countries);
      setState(() {
        appState = persistedState;
      });
    } else {
      print('no persisted state found, opening app with default state..');

      final defaultState = new AppState(
          currentAmount: 1.0,
          currentCurrency: currencyRepository.getBaseRateCurrency(),
          currencyRepo: currencyRepository,
          currencies: new List<String>(),
          countries: countries);

      setState(() {
        appState = defaultState;
      });
    }
  }

  void _updateAndPersist(AppState state) {
    setState(() {
      appState = state;
    });

    _persistState(appState);
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  void toggleIsReconfiguring() {
    // update without persisting
    setState((){
      appState = appState.copyWith(isReconfiguring: !appState.isReconfiguring);
    });
  }

  void removeCurrency(String currencyCode) {
    final currencies = List<String>.from(appState.currencies);
    currencies.remove(currencyCode);
    _updateAndPersist(appState.copyWith(currencies: currencies));
  }

  void addCurrency(String currencyCode) {
    final currencies = List<String>.from(appState.currencies);
    currencies.add(currencyCode);
    _updateAndPersist(appState.copyWith(currencies: currencies));
  }

  void setAmount(double amount, Currency currency) {
    _updateAndPersist(appState.copyWith(amount: amount, currency: currency));
  }

  Future<Null> _persistState(AppState appState) async {
    print('persisting app state..');
    final stateFile = await _localFile;
    await stateFile.writeAsString(json.encode(appState.toJson()));
  }

  Future<String> get _localDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final directory = await _localDirectory;
    return new File('$directory/state.json');
  }

  Future<AppState> _loadState(
      CurrencyRepository currencyRepository, List<Country> countries) async {
    final stateFile = await _localFile;
    final stateJson = json.decode(await stateFile.readAsString());
    return AppState.fromJson(stateJson, currencyRepository, countries);
  }

  Future<List<Country>> _loadCountries(AssetBundle assets) async {
    final countriesJson = await assets.loadString('assets/data/countries.json');

    final List countriesList = JsonDecoder().convert(countriesJson);
    return countriesList.map((country) => Country.fromJson(country)).toList();
  }

  void reorder({String item, String placeAfter}) {
    print("reordering $item to be after $placeAfter..");
    final currencies = List<String>.from(appState.currencies);
    currencies.remove(item);
    final newPosition = currencies.indexOf(placeAfter) + 1;
    currencies.insert(newPosition, item);
    _updateAndPersist(appState.copyWith(
      currencies: currencies
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
