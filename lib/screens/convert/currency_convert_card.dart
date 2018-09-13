import 'package:moneyconverter/l10n/app_localizations.dart';
import 'package:moneyconverter/services/logger.dart';
import 'package:moneyconverter/widgets/animate_in.dart';
import 'package:moneyconverter/app_theme.dart';
import 'package:moneyconverter/screens/convert/convert_dialog.dart';
import 'package:moneyconverter/model/currency.dart';
import 'package:moneyconverter/screens/convert/currency_input_formatter.dart';
import 'package:moneyconverter/state_container.dart';
import 'package:flutter/material.dart';

class CurrencyConvertCard extends StatefulWidget {
  static const height = 65.0;

  static final currencyCodeKey = Key('Currency code');
  static final currencyAmountKey = Key('Currency amount');

  final Currency currency;

  final Duration animationDelay;

  CurrencyConvertCard(
      {@required this.currency,
      @required this.animationDelay});

  @override
  _CurrencyConvertCardState createState() {
    return new _CurrencyConvertCardState();
  }
}

class _CurrencyConvertCardState extends State<CurrencyConvertCard>
    with TickerProviderStateMixin {
  bool _showInputError = false;

  static final log = new Logger<_CurrencyConvertCardState>();

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;
    final localization = AppLocalizations.of(context);

    var currentValue = state.conversion.getAmountInCurrency(widget.currency);

    textEditingController.text =
        CurrencyInputFormatter.formatValue(currentValue);

    Widget currencyName = Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(localization.currencies.getLocalized(widget.currency.code),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14.0)),
      ),
    );

    final icon = widget.currency.icon;
    const flagSize = 32.0;
    final image = Align(
      alignment: Alignment.centerLeft,
      child: new Image(
          image: new AssetImage("assets/images/flags/$icon.png"),
          width: flagSize,
          height: flagSize),
    );

    final contents = new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          Expanded(child: currencyName),
          new Align(
              alignment: Alignment.centerRight,
              child: state.isEditing
                  ? _deleteIcon
                  : _currencyAmount(currentValue))
        ]);

    final card = new Container(
      padding: EdgeInsets.only(bottom: 4.0),
      height: CurrencyConvertCard.height,
      child: new Material(
        color: Colors.transparent,
        child: Card(
            color: _showInputError ? Colors.red : AppTheme.primaryColor,
            child: new InkWell(
              splashColor: AppTheme.accentColor,
              onTap: state.isEditing ? null : _cardTapped,
              child: new Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: contents),
            )),
      ),
    );

    Widget result = _animated(card);
    if (state.isEditing) {
      result = _asDraggable(result);
    }

    return result;
  }

  _currencyAmount(double amount) {
    final currencyAmountFontSize = 24.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(CurrencyInputFormatter.formatValue(amount),
          key: CurrencyConvertCard.currencyAmountKey,
          style: Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(fontSize: currencyAmountFontSize),
        ),
        new Padding(
          padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
          child: Text(widget.currency.code,
              key: CurrencyConvertCard.currencyCodeKey,
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
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: child,
        ),
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
        ));
  }

  _animated(Widget child) {
    return new AnimateIn(child: child, delay: widget.animationDelay);
  }

  void _newValueReceived(String valueString) {
    log.event("converting $valueString ${widget.currency.code}");
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
