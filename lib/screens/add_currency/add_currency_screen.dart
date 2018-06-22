import 'package:backpacking_currency_converter/helpers/sorting.dart';
import 'package:backpacking_currency_converter/screens/add_currency/available_currency_card.dart';
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

  @override
  void didChangeDependencies() {
    final currencyRepo = StateContainer.of(context).appState.currencyRepo;
    currencies = sorted(currencyRepo.getAllCurrencies());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appState = StateContainer.of(context).appState;

    final currencyWidgets = this
        .currencies
        .map((currency) => new AvailableCurrencyCard(currency))
        .toList();

    final searchField = new CurrencySearchTextField(
      allCurrencies: appState.currencyRepo.getAllCurrencies(),
      countries: appState.countries,
      filterChanged: (currencies) {
        setState(() {
          this.currencies = sorted(currencies);
        });
      },
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

  sorted(List<Currency> currencies) {
    return alphabeticallySorted(currencies, (currency) => currency.name);
  }
}
