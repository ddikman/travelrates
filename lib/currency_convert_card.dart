import 'package:backpacking_currency_converter/animate_in.dart';
import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/convert_dialog.dart';
import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/currency_input_formatter.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:flutter/material.dart';

class CurrencyConvertCard extends StatefulWidget {
  static const height = 65.0;

  final Currency currency;

  final ValueChanged<double> onNewAmount;

  final int index;

  final bool animate;

  CurrencyConvertCard(
      {@required this.currency,
        @required this.onNewAmount,
        @required this.index,
        this.animate = false});

  @override
  _CurrencyConvertCardState createState() {
    return new _CurrencyConvertCardState();
  }
}

class _CurrencyConvertCardState extends State<CurrencyConvertCard>
    with TickerProviderStateMixin {
  bool _showInputError = false;

  final TextEditingController textEditingController = TextEditingController();

  _currencyAmount(double amount) {
    final currencyAmountFontSize = 24.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          CurrencyInputFormatter.formatValue(amount),
          style: Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(fontSize: currencyAmountFontSize),
        ),
        new Padding(
          padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
          child: Text(widget.currency.code,
              style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: currencyAmountFontSize / 2)),
        )
      ],
    );
  }

  get _deleteIcon {
    return IconButton(
      padding: EdgeInsets.all(0.0),
      iconSize: 24.0,
      icon: Icon(Icons.delete, color: AppTheme.accentColor),
      onPressed: () {
        StateContainer.of(context).removeCurrency(widget.currency.code);
      },
    );
  }

  _asDraggable(Widget child) {
    final screenWidth = MediaQuery.of(context).size.width;
    return new Draggable(
        data: widget.currency,
        affinity: Axis.vertical,
        child: child,
        childWhenDragging: Opacity(opacity: 0.5, child: child,),
        feedback: new Opacity(
          opacity: 0.8,
          child: new Container(
            width: screenWidth - 16.0 * 2,
            child: Card(
              color: AppTheme.primaryColor,
              child: Center(
                  child: new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('${widget.currency.name}',
                        style: TextStyle(color: AppTheme.accentColor)),
                  )),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    var currentValue = state.getAmountInCurrency(widget.currency);

    textEditingController.text =
        CurrencyInputFormatter.formatValue(currentValue);

    Widget currencyTitle = Text(widget.currency.name,
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14.0));


    final contents = new Stack(
      children: <Widget>[
        currencyTitle,
        new Align(
            alignment: Alignment.centerRight,
            child: state.isReconfiguring ? _deleteIcon : _currencyAmount(currentValue)
        )
      ],
    );

    if (state.isReconfiguring) {
      final moveHandle = new Align(
          alignment: Alignment.bottomLeft,
          child: Icon(Icons.dehaze, size: 24.0, color: AppTheme.accentColor));
      contents.children.insert(0, moveHandle);
    }

    final card = new Container(
      height: CurrencyConvertCard.height,
      child: new Material(
        color: Colors.transparent,
        child: Card(
            color: _showInputError ? Colors.red : AppTheme.primaryColor,
            child: new InkWell(
              splashColor: AppTheme.accentColor,
              onTap: state.isReconfiguring ? null : _cardTapped,
              child: new Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: contents
              ),
            )),
      ),
    );

    return _asDraggable(widget.animate ? _animated(card) : card);
  }

  _animated(Widget child) {
    final animationDelay = Duration(milliseconds: 50 * (widget.index + 1));
    return new AnimateIn(child: child, delay: animationDelay);
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