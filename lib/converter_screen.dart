import 'package:backpacking_currency_converter/animate_in.dart';
import 'package:backpacking_currency_converter/app_routes.dart';
import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/background_container.dart';
import 'package:backpacking_currency_converter/convert_dialog.dart';
import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/currency_input_formatter.dart';
import 'package:backpacking_currency_converter/position_finder.dart';
import 'package:backpacking_currency_converter/state_container.dart';

import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {
  @override
  _ConvertScreenState createState() {
    return new _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {
  Widget _buildCard(int index, String currencyCode) {
    final state = StateContainer.of(context).appState;

    var currency = state.currencyRepo.getCurrencyByCode(currencyCode);
    final card = CurrencyCard(
        currency: currency,
        onNewAmount: (value) {},
        index: index,
        animate: false);

    return _withReorderDropArea(card);
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    const spacing = 12.0;
    const floatingButtonSpacing = 60.0;

    int index = 0;
    final cards = new Material(
      color: Colors.transparent,
      child: new Padding(
        padding: const EdgeInsets.only(bottom: floatingButtonSpacing),
        // add space for float button
        child: new ListView(
          padding: EdgeInsets.all(spacing),
          children: state.currencies
              .map((currency) => _buildCard(index++, currency))
              .toList(),
        ),
      ),
    );

    final body = new PositionFinder(
        child: new Container(color: Colors.transparent, child: cards));

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
        Navigator.of(context).pushNamed(AppRoutes.addCurrency);
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

  Widget _withReorderDropArea(CurrencyCard card) {

    const iconSize = 24.0;
    final dropArea = new Align(
      alignment: Alignment.bottomCenter,
      child: new DragTarget<Currency>(
        builder: (BuildContext context, List candidateData, List rejectedData) {
          bool hovered = candidateData.isNotEmpty;
          final dropAreaHeight = hovered ? (CurrencyCard.height + iconSize) : CurrencyCard.height;
          return new FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              height: dropAreaHeight,
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: hovered ? 1.0 : 0.0,
                child: Icon(
                  Icons.add_circle,
                  color: AppTheme.accentColor,
                  size: 24.0,
                ),
              ),
            ),
          );
        },
        onAccept: (value) {
          // handle the reorder. since we dropped the other card on this card
          // it means we want to place it _after_ this card
          StateContainer.of(context).reorder(
            item: value.code,
            placeAfter: card.currency.code
          );
        },
        onWillAccept: (value) => value.code != card.currency.code,
      ),
    );

    return Stack(
      children: <Widget>[
        card,
        dropArea
      ],
    );
  }
}

class CurrencyCard extends StatefulWidget {
  static const height = 65.0;

  final Currency currency;

  final ValueChanged<double> onNewAmount;

  final int index;

  final bool animate;

  CurrencyCard(
      {@required this.currency,
      @required this.onNewAmount,
      @required this.index,
      this.animate = false});

  @override
  _CurrencyCardState createState() {
    return new _CurrencyCardState();
  }
}

class _CurrencyCardState extends State<CurrencyCard>
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
      height: CurrencyCard.height,
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
