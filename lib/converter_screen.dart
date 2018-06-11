
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

  Widget _buildCard(String currencyCode){
    final state = StateContainer.of(context).appState;

    var currency = state.currencyRepo.getCurrencyByCode(currencyCode);
    return CurrencyCard(
        currency: currency,
        onNewAmount: (value) {
        },
    );
  }

  @override
  Widget build(BuildContext context) {

    final spacing = 12.0;

    final cards = new Material(
      color: Colors.transparent,
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(spacing),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.1,
        children: <Widget>[
          _buildCard('USD'),
          _buildCard('IDR'),
          _buildCard('SEK'),
          _buildCard('SGD'),
          _buildCard('JPY'),
          _buildCard('EUR'),
        ],
      ),
    );

    return new Container(
      color: Colors.transparent,
        child: cards
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
                children: <Widget>[
                  Text(
                      widget.currency.name,
                      style: Theme.of(context).textTheme.body1
                          .copyWith(
                          fontSize: 14.0
                      )
                  ),
                  TextField(
                    focusNode: focusNode,
                  controller: textEditingController,
                  style: Theme.of(context).textTheme.body1
                      .copyWith(
                    fontSize: inputFontSize,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    isDense: true,
                    suffixText: "${widget.currency.code}",
                    suffixStyle: Theme.of(context).textTheme.body1.copyWith(
                      fontSize: inputFontSize / 2
                    ),
                    border: InputBorder.none,
                    errorText: _showInputError ? 'Input a valid decimal.' : null,
                    errorStyle: TextStyle(
                      color: Colors.white,
                    )
                    ),
                  onSubmitted: _newValueReceived,
                    )
                ],
              ),
            ),
          )
      ),
    );
  }


  void _newValueReceived(String valueString) {
    double amount = double.tryParse(valueString);
    if (amount == null)
    {
      setState((){
        _showInputError = true;
      });
      return;
    }

    final stateContainer = StateContainer.of(context);
    stateContainer.setAmount(amount, widget.currency);
    setState((){
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
        affinity: TextAffinity.upstream
    );
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