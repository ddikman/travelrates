import 'package:moneyconverter/app_theme.dart';
import 'package:moneyconverter/model/currency.dart';
import 'package:moneyconverter/screens/add_currency/add_currency_button.dart';
import 'package:moneyconverter/state_container.dart';
import 'package:flutter/material.dart';

class AvailableCurrencyCard extends StatelessWidget {
  final Currency currency;

  AvailableCurrencyCard(this.currency);

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    Widget textWidget = Text(
      "${currency.name}, ${currency.symbol}",
      style: TextStyle(fontSize: 18.0),
    );

    final relatedCountries = state.countries
        .where((country) => country.currencyCode == currency.code)
        .toList();
    if (relatedCountries.length > 1) {
      final countryNames =
      relatedCountries.map((country) => country.name).join(", ");
      textWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          textWidget,
          Text(countryNames, style: TextStyle(fontSize: 10.0))
        ],
      );
    }

    final currencyCard = Card(
      color: AppTheme.primaryColor,
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            new Expanded(child: textWidget),
            new AddCurrencyButton(currency: currency)
          ],
        ),
      ),
    );

    return currencyCard;
  }
}