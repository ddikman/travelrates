import 'package:backpacking_currency_converter/background_container.dart';
import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:backpacking_currency_converter/country.dart';
import 'package:flutter/material.dart';

class CurrenciesScreen extends StatefulWidget {
  @override
  CurrenciesScreenState createState() {
    return new CurrenciesScreenState();
  }
}

class CurrenciesScreenState extends State<CurrenciesScreen> {

  List<Currency> currencies;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterCurrencies('');
  }

  @override
  Widget build(BuildContext context) {

    final currencyWidgets = currencies.map((currency) {
      return CurrencySelection(currency);
    }).toList();

    final searchField = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        onChanged: _filterCurrencies,
        style: TextStyle(
          color: Colors.white
        ),
        decoration: InputDecoration(
            labelText: 'Search currency code or name',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            border: OutlineInputBorder()
        ),
      ),
    );

    final body = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Card(
            color: Colors.blue,
            child: searchField
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

  void _filterCurrencies(String filter) {
    final state = StateContainer.of(context).appState;

    filter = filter.toLowerCase();

    setState(() {
      currencies = state.currencyRepo.getAllCurrencies();
      currencies.sort((currencyA, currencyB) {
        return currencyA.name.toLowerCase().compareTo(currencyB.name.toLowerCase());
      });

      if (filter.isNotEmpty) {
        final List<Country> matchingCountries = List.from(state.countries);
        matchingCountries.retainWhere((country) => country.name.toLowerCase().contains(filter));

        currencies.retainWhere((currency) {
          return currency.name.toLowerCase().contains(filter) ||
              currency.code.toLowerCase().contains(filter) ||
              matchingCountries.any((country) => country.currencyCode == currency.code);
        });
      }
    });
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
  bool _alreadyAdded;

  @override
  Widget build(BuildContext context) {

    final state = StateContainer.of(context).appState;
    _alreadyAdded = state.currencies.contains(widget.currency.code);


    Widget textWidget = Text(
    "${widget.currency.name}, ${widget.currency.symbol}",
    style: TextStyle(fontSize: 18.0),
    );

    final relatedCountries = state.countries.where((country) => country.currencyCode == widget.currency.code).toList();
    if (relatedCountries.length > 1) {
      final countryNames = relatedCountries.map((country) => country.name).join(", ");
      textWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          textWidget,
          Text(
            countryNames,
            style: TextStyle(fontSize: 10.0)
          )
        ],
      );
    }

    final currencyCard = Card(
      color: Colors.blue,
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            new Expanded(
              child: textWidget
            ),
            _buildAddIcon()
          ],
        ),
      ),
    );

    return currencyCard;
  }

  _buildAddIcon() {

    final disabledTransparency = _alreadyAdded ? 0.5 : 1.0;

    return new GestureDetector(
      child: Icon(
          Icons.add_circle,
          size: 24.0,
          color: Color.fromRGBO(255, 255, 255, disabledTransparency),
      ),
      onTap: () {
        final stateContainer = StateContainer.of(context);

        if (_alreadyAdded) {
          print("${widget.currency.name} already added, showing snack instead");
          Scaffold.of(context).showSnackBar(new SnackBar(
              content: Text("${widget.currency.name} is already selected!")
          ));
        } else {
          stateContainer.addCurrency(widget.currency.code);

          // return to previous screen
          Navigator.of(context).pop();
        }
      },
    );
  }
}
