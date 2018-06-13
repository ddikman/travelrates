import 'package:backpacking_currency_converter/background_container.dart';
import 'package:backpacking_currency_converter/base_currency_screen.dart';
import 'package:backpacking_currency_converter/currencies_screen.dart';
import 'package:backpacking_currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:backpacking_currency_converter/state_container.dart';

class ConverterScreen extends StatefulWidget {
  @override
  ConverterScreenState createState() {
    return new ConverterScreenState();
  }
}

class ConverterScreenState extends State<ConverterScreen> {
  Widget _buildCard(String currencyCode) {
    final state = StateContainer.of(context).appState;

    var currency = state.currencyRepo.getCurrencyByCode(currencyCode);
    return CurrencyCard(
      currency: currency,
      onNewAmount: (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    final spacing = 12.0;

    final cards = new Material(
      color: Colors.transparent,
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(spacing),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.62,
        children: state.currencies.map(_buildCard).toList(),
      ),
    );

    final body = new Container(color: Colors.transparent, child: cards);

    return Scaffold(
        appBar: AppBar(
          title: Text("What's my \$ worth?"),
        ),
        drawer: _buildAppDrawer(context),
        body: new BackgroundContainer(child: body));
  }

  _buildAppDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new DrawerHeader(
            child: new Column(
              children: <Widget>[
                Text(
                  "Backpacker currency converter",
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                new Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Copyright Greycastle AB, 2018',
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          new ListTile(
            title: Row(
              children: <Widget>[
                new Expanded(child: new Text("Manage currencies")),
                Icon(Icons.monetization_on, color: Colors.black),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new CurrenciesScreen()));
            },
          ),
          new ListTile(
            title: Row(
              children: <Widget>[
                new Expanded(child: new Text('Set base currency')),
                Icon(Icons.settings, color: Colors.black)
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new BaseCurrencyScreen()));
            },
          )
        ],
      ),
    );
  }
}

class CurrencyCard extends StatefulWidget {
  final Currency currency;

  final ValueChanged<double> onNewAmount;

  CurrencyCard({@required this.currency, @required this.onNewAmount});

  @override
  _CurrencyCardState createState() {
    return new _CurrencyCardState();
  }
}

class _CurrencyCardState extends State<CurrencyCard> {
  bool _showInputError = false;

  final FocusNode focusNode = FocusNode();

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(gotFocus);
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;
    var currentValue = state.getAmountInCurrency(widget.currency);

    textEditingController.text = _formatValue(currentValue);

    final inputFontSize = 24.0;

    return new Material(
      color: Colors.transparent,
      child: Card(
          color: _showInputError ? Colors.red : Colors.blue,
          child: new InkWell(
            splashColor: Colors.white,
            onTap: _cardTapped,
            child: new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.currency.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 14.0)),
                  TextField(
                    focusNode: focusNode,
                    controller: textEditingController,
                    style: Theme.of(context).textTheme.body1.copyWith(
                          fontSize: inputFontSize,
                        ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        isDense: true,
                        suffixText: "${widget.currency.code}",
                        suffixStyle: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: inputFontSize / 2),
                        border: InputBorder.none,
                        errorText:
                            _showInputError ? 'Input a valid decimal.' : null,
                        errorStyle: TextStyle(
                          color: Colors.white,
                        )),
                    onSubmitted: _newValueReceived,
                  )
                ],
              ),
            ),
          )),
    );
  }

  void _newValueReceived(String valueString) {
    double amount = double.tryParse(valueString);
    if (amount == null) {
      setState(() {
        _showInputError = true;
      });
      return;
    }

    final stateContainer = StateContainer.of(context);
    stateContainer.setAmount(amount, widget.currency);
    setState(() {
      _showInputError = false;
    });
  }

  void _cardTapped() {
    print('${widget.currency.name} was pressed');
    focusText();
  }

  void focusText() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void selectAllText() {
    final textLength = textEditingController.value.text.length;
    textEditingController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textLength,
        affinity: TextAffinity.upstream);
  }

  void gotFocus() {
    selectAllText();
  }

  _formatValue(double currentValue) {
    final locale = Intl.getCurrentLocale();
    NumberFormat format;
    if (currentValue < 100) {
      format = NumberFormat('###,###.##', locale);
    } else if (currentValue < 10000) {
      format = NumberFormat('###,###', locale);
    } else {
      // if we have a number above 10k
      // it's better we start removing insignificant numbers
      currentValue = (currentValue / 100.0).roundToDouble() * 100.0;
      format = NumberFormat('###,###', locale);
    }

    return format.format(currentValue);
  }
}
