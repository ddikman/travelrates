import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/widgets/animate_in.dart';
import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/screens/convert/convert_dialog.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/screens/convert/currency_input_formatter.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';

class CurrencyConvertCard extends StatefulWidget {
  static const height = 65.0;

  final Currency currency;

  final Duration animationDelay;

  CurrencyConvertCard(
      {@required this.currency,
      @required this.animationDelay,
      Key key}) : super(key: key);

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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0)),
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
              child: _currencyAmount(currentValue))
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
              onTap: _showConvertDialog,
              child: new Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: contents),
            )),
      ),
    );

    return _animated(card);
  }

  _currencyAmount(double amount) {
    final currencyAmountFontSize = 24.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(CurrencyInputFormatter.formatValue(amount),
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

  void _showConvertDialog() {
    showDialog(
        context: context,
        builder: (context) => new ConvertDialog(
          currencyCode: widget.currency.code,
          onSubmitted: _newValueReceived,
        ));
  }
}
