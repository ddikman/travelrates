import 'package:intl/intl.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/currency_card.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/use_cases/main_screen/ui/compare_keyboard_sheet.dart';
import 'package:travelconverter/widgets/animate_in.dart';
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

    final contents = new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localization.currencies.getLocalized(widget.currency.code),
                  style: ThemeTypography.small.bold),
              Text(widget.currency.code, style: ThemeTypography.verySmall.bold)
            ],
          ),
          Gap.medium,
          Expanded(
            child: Text(
              key: Key('ValueDisplay'),
              _formatValue(currentValue),
              textAlign: TextAlign.right,
              style: ThemeTypography.large,
            ),
          )
        ]);

    final card = CurrencyCard(
        content: contents,
        onTap: () => _showConvertDialog(currentValue),
        currencyIconName: widget.currency.icon);

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

  void _showConvertDialog(double currentValue) async {
    double? value = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => CompareKeyboardSheet(
            currencyCode: widget.currency.code, initialValue: currentValue));

    if (value != null) {
      _newValueReceived(value);
    }
  }
}
