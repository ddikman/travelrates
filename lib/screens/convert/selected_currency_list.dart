import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/title_text.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/use_cases/main_screen/ui/compare_currency_card.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SelectedCurrencyList extends StatelessWidget {
  static const int _msDelayBetweenItemAppearance = 60;

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    int index = 0;
    final currencies = state.conversion.currencies
        .map((currency) => _buildCurrencyEntry(context, index++, currency))
        .toList();

    return ListView(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [TitleText('Currency comparisons'), Gap.list, ...currencies]);
  }

  Widget _buildCurrencyEntry(
      BuildContext context, int index, String currencyCode) {
    final state = StateContainer.of(context).appState;

    final delayMs = _msDelayBetweenItemAppearance * (index + 1);
    final animationDelay = Duration(milliseconds: delayMs);
    var currency = state.availableCurrencies.getByCode(currencyCode);

    return CompareCurrencyCard(
            currency: currency, animationDelay: animationDelay)
        .pad(bottom: Paddings.listGap);
  }
}
