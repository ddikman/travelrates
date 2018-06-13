import 'package:backpacking_currency_converter/background_container.dart';
import 'package:backpacking_currency_converter/base_currency_screen.dart';
import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:flutter/material.dart';

class CurrenciesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    final currencyWidgets =
        state.currencyRepo.getAllCurrencies().map((currency) {
      return CurrencySelection(currency);
    }).toList();

    final body = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Card(
            color: Colors.blue,
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search code or name',
                  border: OutlineInputBorder()
              ),
            ),
          ),
          new Expanded(child: ListView(children: currencyWidgets)),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Select currencies')),
      body: BackgroundContainer(child: body)
    );
  }
}

class CurrencySelection extends StatefulWidget {
  final Currency currency;

  CurrencySelection(this.currency);

  @override
  _CurrencySelectionState createState() {
    return new _CurrencySelectionState();
  }
}

class _CurrencySelectionState extends State<CurrencySelection> {
  bool _isSelected;

  @override
  Widget build(BuildContext context) {

    final state = StateContainer.of(context).appState;
    _isSelected = state.currencies.contains(widget.currency.code);

    return Card(
      color: Colors.blue,
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            new Expanded(
              child: Text(
                "${widget.currency.symbol} ${widget.currency.name}",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            _buildToggleIcon()
          ],
        ),
      ),
    );
  }

  _buildToggleIcon() {
    return new GestureDetector(
      child: Icon(_isSelected ? Icons.star : Icons.star_border, size: 30.0),
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });

        final stateContainer = StateContainer.of(context);
        if (_isSelected) {
          stateContainer.addCurrency(widget.currency.code);
        } else {
          stateContainer.removeCurrency(widget.currency.code);
        }
      },
    );
  }
}
