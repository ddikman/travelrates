import 'package:backpacking_currency_converter/screens/add_currency/available_currency_card.dart';
import 'package:backpacking_currency_converter/screens/add_currency/currency_filter.dart';
import 'package:backpacking_currency_converter/screens/add_currency/currency_search_text_field.dart';
import 'package:backpacking_currency_converter/widgets/background_container.dart';
import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/state_container.dart';
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
          title: Text('ADD CURRENCY'),
          centerTitle: true,
          bottom: new PreferredSize(
            child: searchField,
            preferredSize: const Size.fromHeight(60.0),
          ),
        ),
        body: BackgroundContainer(child: body));
  }

  _applyFilter(String filterText) {
    setState((){
      this.currencies = currencyFilter.getFiltered(filterText);
    });
  }
}
