import 'package:flutter_animate/flutter_animate.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/use_cases/home/ui/compare_currency_card.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConvertibleCurrenciesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    int index = 0;
    final currencies = state.conversion.currencies
        .map((currency) => _buildCurrencyEntry(context, index++, currency))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Currency comparisons', style: ThemeTypography.title),
        Gap.list,
        ...AnimateList(effects: [
          FadeEffect(curve: Curves.ease),
          MoveEffect(begin: Offset(0.0, 75.0), curve: Curves.fastOutSlowIn)
        ], children: currencies, interval: 80.ms)
            .toList()
      ],
    );
  }

  Widget _buildCurrencyEntry(
      BuildContext context, int index, String currencyCode) {
    final state = StateContainer.of(context).appState;

    var currency = state.availableCurrencies.getByCode(currencyCode);

    return CompareCurrencyCard(currency: currency)
        .pad(bottom: Paddings.listGap);
  }
}
