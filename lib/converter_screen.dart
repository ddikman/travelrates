import 'package:backpacking_currency_converter/animate_in.dart';
import 'package:backpacking_currency_converter/background_container.dart';
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
  Widget _buildCard(int index, String currencyCode) {
    final state = StateContainer.of(context).appState;

    var currency = state.currencyRepo.getCurrencyByCode(currencyCode);
    return CurrencyCard(
        currency: currency, onNewAmount: (value) {}, index: index);
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    final spacing = 12.0;

    int index = 0;
    final cards = new Material(
      color: Colors.transparent,
      child: new Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        // add space for float button
        child: new ListView(
          padding: EdgeInsets.all(spacing),
          children: state.currencies
              .map((currency) => _buildCard(index++, currency))
              .toList(),
        ),
      ),
    );

    final body = new Container(color: Colors.transparent, child: cards);

    return Scaffold(
        appBar: AppBar(
          title: Text("How much is.."),
          actions: <Widget>[_buildConfigureActionButton()],
        ),
        floatingActionButton: _buildAddCurrencyButton(),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: new BackgroundContainer(child: body));
  }

  _buildAddCurrencyButton() {
    final floatingButton = FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed('/addCurrency');
      },
    );

    return floatingButton;
  }

  _buildConfigureActionButton() {
    final state = StateContainer.of(context).appState;
    IconData displayIcon = state.isReconfiguring ? Icons.done : Icons.settings;

    return new IconButton(
        icon: Icon(displayIcon),
        onPressed: () {
          StateContainer.of(context).toggleIsReconfiguring();
        });
  }
}

class CurrencyCard extends StatefulWidget {
  final Currency currency;

  final ValueChanged<double> onNewAmount;

  final int index;

  CurrencyCard(
      {@required this.currency,
      @required this.onNewAmount,
      @required this.index});

  @override
  _CurrencyCardState createState() {
    return new _CurrencyCardState();
  }
}

class _CurrencyCardState extends State<CurrencyCard>
    with TickerProviderStateMixin {
  bool _showInputError = false;

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;
    var currentValue = state.getAmountInCurrency(widget.currency);

    textEditingController.text = formatValue(currentValue);

    final currencyAmountFontSize = 24.0;

    Widget currencyTitle = Text(widget.currency.name,
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14.0));

    Widget currencyAmount = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          formatValue(currentValue),
          style: Theme.of(context).textTheme.body1.copyWith(
            fontSize: currencyAmountFontSize
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
          child: Text(
            widget.currency.code,
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(fontSize: currencyAmountFontSize / 2)
          ),
        )
      ],
    );

    // if we're editing, add an edit button
    if (state.isReconfiguring) {
      currencyAmount = IconButton(
        padding: EdgeInsets.all(0.0),
        iconSize: 24.0,
        icon: Icon(Icons.delete, color: Colors.white),
        onPressed: () {
          StateContainer.of(context).removeCurrency(widget.currency.code);
        },
      );
    }

    final card = new Container(
      height: 65.0,
      child: new Material(
        color: Colors.transparent,
        child: Card(
            color: _showInputError ? Colors.red : Colors.blue,
            child: new InkWell(
              splashColor: Colors.white,
              onTap: _cardTapped,
              child: new Padding(
                padding: const EdgeInsets.all(4.0),
                child: new Stack(
                  children: <Widget>[
                    currencyTitle,
                    new Align(
                        alignment: Alignment.centerRight, child: currencyAmount)
                  ],
                ),
              ),
            )),
      ),
    );

    final animationDelay = Duration(milliseconds: 50 * (widget.index + 1));

    return new AnimateIn(child: card, delay: animationDelay);
  }

  void _newValueReceived(String valueString) {
    print("trying to convert $valueString ${widget.currency.code}");
    double amount = double.tryParse(valueString.replaceAll(',', ''));
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
    showDialog(
        context: context,
        builder: (context) => new ConvertDialog(
              currencyCode: widget.currency.code,
              onSubmitted: _newValueReceived,
            ));
  }
}

class ConvertDialog extends StatelessWidget {
  final ValueChanged<String> onSubmitted;

  final String currencyCode;

  final textFieldController = new TextEditingController();

  ConvertDialog({Key key, this.onSubmitted, this.currencyCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = new TextField(
      controller: textFieldController,
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: [
        new WhitelistingTextInputFormatter(new RegExp(r'[\d\.]+')),
        new CurrencyInputFormatter()
      ],
      onSubmitted: (value) => _submit(context),
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: '$currencyCode to convert'),
    );

    final submitButton = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new FlatButton(
          onPressed: () => _submit(context),
          child: new Text(
            'Convert',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
        ),
      ),
    );

    return new Dialog(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[textField, submitButton],
        ),
      ),
    );
  }

  _submit(BuildContext context) {
    Navigator.of(context).pop();
    onSubmitted(textFieldController.text);
  }
}

// credits to Mr Jorge Viera @ stack overflow:
// https://stackoverflow.com/questions/50395032/flutter-textfield-with-currency-format
class CurrencyInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.selection.baseOffset == 0){
      print(true);
      return newValue;
    } else if (newValue.text.endsWith('.')) {
      return newValue;
    }

    double value = double.parse(newValue.text.replaceAll(',', ''));
    final formatted = formatValue(value);

    return newValue.copyWith(
        text: formatted,
        selection: new TextSelection.collapsed(offset: formatted.length));
  }
}

String formatValue(double value) {
  final locale = Intl.getCurrentLocale();
  NumberFormat format;
  if (value < 100) {
    format = NumberFormat('###,###.##', locale);
  } else if (value < 10000) {
    format = NumberFormat('###,###', locale);
  } else {
    // if we have a number above 10k
    // it's better we start removing insignificant numbers
    value = (value / 100.0).roundToDouble() * 100.0;
    format = NumberFormat('###,###', locale);
  }

  return format.format(value);
}