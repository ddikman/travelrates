import 'package:intl/intl.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/common_card.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/widgets/animate_in.dart';
import 'package:travelconverter/screens/convert/convert_dialog.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';

class CompareCurrencyCard extends StatefulWidget {
  static const height = 65.0;

  final Currency currency;

  final Duration animationDelay;

  CompareCurrencyCard({required this.currency, required this.animationDelay});

  @override
  _CompareCurrencyCardState createState() {
    return new _CompareCurrencyCardState();
  }
}

class _CompareCurrencyCardState extends State<CompareCurrencyCard>
    with TickerProviderStateMixin {
  static final log = new Logger<_CompareCurrencyCardState>();

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;
    final localization = AppLocalizations.of(context);

    var currentValue = state.conversion.getAmountInCurrency(widget.currency);

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
          Gap.medium,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localization.currencies.getLocalized(widget.currency.code),
                  style: ThemeTypography.smallBold),
              Text(widget.currency.code, style: ThemeTypography.verySmallBold)
            ],
          ),
          Gap.medium,
          Expanded(
            child: Text(
              _formatValue(currentValue),
              textAlign: TextAlign.right,
              style: ThemeTypography.large,
            ),
          )
        ]);

    final card = CommonCard(child: contents, onTap: _showConvertDialog);

    return _animated(card);
  }

  _animated(Widget child) {
    return new AnimateIn(child: child, delay: widget.animationDelay);
  }

  String _formatValue(double value) {
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

    format = NumberFormat('###,###.##', locale);
    return format.format(value);
  }

  void _newValueReceived(double value) {
    log.event("convert", "converting $value ${widget.currency.code}",
        parameters: {'currency': widget.currency.code, 'amount': value});
    final stateContainer = StateContainer.of(context);
    stateContainer.setAmount(value, widget.currency);
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
