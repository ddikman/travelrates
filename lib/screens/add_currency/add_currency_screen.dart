import 'package:intl/intl.dart';
import 'package:moneyconverter/screens/add_currency/available_currency_card.dart';
import 'package:moneyconverter/screens/add_currency/currency_filter.dart';
import 'package:moneyconverter/screens/add_currency/currency_search_text_field.dart';
import 'package:moneyconverter/widgets/background_container.dart';
import 'package:moneyconverter/model/currency.dart';
import 'package:moneyconverter/state_container.dart';
import 'package:flutter/material.dart';

class AddCurrencyScreen extends StatefulWidget {
  @override
  _AddCurrencyScreenState createState() {
    return new _AddCurrencyScreenState();
  }
}

class _AddCurrencyScreenState extends State<AddCurrencyScreen> {
  List<Currency> currencies;
  CurrencyFilter currencyFilter;

  @override
  void didChangeDependencies() {
    // load initial state once
    if (this.currencyFilter == null) {
      final state = StateContainer
          .of(context)
          .appState;

      currencyFilter = new CurrencyFilter(state.availableCurrencies.getList(), state.countries);
      _applyFilter('');
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final currencyWidgets = this
        .currencies
        .map((currency) => new AvailableCurrencyCard(currency))
        .toList();

    final searchField = new CurrencySearchTextField(
      filterChanged: _applyFilter,
    );

    final body = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: currencyWidgets));

    return Scaffold(
        appBar: AppBar(
          title: Text(_screenTitle),
          centerTitle: true,
          bottom: new PreferredSize(
            child: searchField,
            preferredSize: const Size.fromHeight(60.0),
          ),
        ),
        body: BackgroundContainer(child: body));
  }

  String get _screenTitle => Intl.message(
    "ADD CURRENCY",
    desc: "Add currency screen title."
  );

  _applyFilter(String filterText) {
    setState((){
      this.currencies = currencyFilter.getFiltered(filterText);
    });
  }
}
