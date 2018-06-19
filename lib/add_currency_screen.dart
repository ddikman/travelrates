import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/background_container.dart';
import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:backpacking_currency_converter/country.dart';
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
    super.didChangeDependencies();
    _filterCurrencies('');
  }

  @override
  Widget build(BuildContext context) {

    final currencyWidgets = currencies.map((currency) {
      return CurrencySelection(currency);
    }).toList();

    final searchField = new Padding(
      padding: EdgeInsets.all(14.0),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
        ),
        child: TextField(
          autofocus: true,
          onChanged: _filterCurrencies,
          style: TextStyle(
            color: AppTheme.primaryColor
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4.0),
              labelText: "Search country or currency code",
              hintText: "Search country or currency code",
            border: InputBorder.none
          ),
        ),
      ),
    );

    final body = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: currencyWidgets)
    );

    return Scaffold(
      appBar: AppBar(
          title: Text('Add currency'),
        bottom: new PreferredSize(
          child: searchField,
          preferredSize: const Size.fromHeight(60.0),
        ),
      ),
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
      color: AppTheme.primaryColor,
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
