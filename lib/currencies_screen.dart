import 'package:backpacking_currency_converter/currency_repository.dart';
import 'package:flutter/material.dart';

class CurrenciesScreen extends StatelessWidget {

  final CurrencyRepository currencyRepository;

  const CurrenciesScreen({Key key, this.currencyRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyWidgets = currencyRepository.getAllCurrencies()
        .map((currency) {
      return Card(
        color: Colors.blue,
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("${currency.symbol} ${currency.name}"),
                Text("${currency.name}")
              ],
            ),
            new Align(
              alignment: Alignment.centerRight,
                child: Icon(Icons.star, size: 30.0))
          ],
        ),
      );
    }).toList();

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
          children: currencyWidgets
      ),
    );
  }
}