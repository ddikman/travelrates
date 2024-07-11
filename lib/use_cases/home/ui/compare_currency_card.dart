import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';
import 'package:travelconverter/app_core/widgets/currency_card.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/use_cases/home/state/converted_amount_provider.dart';
import 'package:travelconverter/use_cases/home/ui/custom_keyboard_sheet.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';

class CompareCurrencyCard extends ConsumerWidget {
  static const height = 65.0;

  final Currency currency;

  CompareCurrencyCard({required this.currency});

  static final log = new Logger<CompareCurrencyCard>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final currentValue = ref.watch(convertedAmountProvider(currency));

    final contents = new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localization.currencies.getLocalized(currency.code),
                  style: ThemeTypography.small.bold),
              Text(currency.code, style: ThemeTypography.verySmall.bold)
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

    return CurrencyCard(
        content: contents,
        onTap: () => _showConvertDialog(context, currentValue),
        currencyIconName: currency.icon);
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

  void _newValueReceived(BuildContext context, double value) {
    log.event("convert", "converting $value ${currency.code}",
        parameters: {'currency': currency.code, 'amount': value});
    final stateContainer = StateContainer.of(context);
    stateContainer.setAmount(value, currency);
  }

  void _showConvertDialog(BuildContext context, double currentValue) async {
    double? value = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => CustomKeyboardSheet(
            currencyCode: currency.code, initialValue: currentValue));

    if (value != null) {
      _newValueReceived(context, value);
    }
  }
}
