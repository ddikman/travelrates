import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/use_cases/currency_selection/state/selected_currencies_notifier.dart';
import 'package:travelconverter/use_cases/home/ui/compare_currency_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConvertibleCurrenciesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencies = ref
        .watch(selectedCurrenciesNotifierProvider)
        .map((currency) => CompareCurrencyCard(currency: currency)
            .pad(bottom: Paddings.listGap))
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
}
