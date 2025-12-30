import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/helpers/time_formatter.dart';
import 'package:travelconverter/l10n/l10n_extension.dart';
import 'package:travelconverter/state_container.dart';
import 'package:travelconverter/use_cases/currency_selection/state/selected_currencies_notifier.dart';
import 'package:travelconverter/use_cases/home/ui/compare_currency_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConvertibleCurrenciesList extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConvertibleCurrenciesList> createState() =>
      _ConvertibleCurrenciesListState();
}

class _ConvertibleCurrenciesListState
    extends ConsumerState<ConvertibleCurrenciesList> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = ref
        .watch(selectedCurrenciesNotifierProvider)
        .map((currency) => CompareCurrencyCard(currency: currency)
            .pad(bottom: Paddings.listGap))
        .toList();

    final stateContainer = StateContainer.of(context);
    final ratesLastUpdated = stateContainer.appState.ratesLastUpdated;
    final ratesLoading = stateContainer.ratesLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.currency_comparisons, style: ThemeTypography.title),
        if (ratesLoading) ...[
          SizedBox(height: 4),
          Text(
            'Updating exchange rates..',
            style: ThemeTypography.verySmall.copyWith(
              color: context.themeColors.text60,
            ),
          ),
        ] else if (ratesLastUpdated != null) ...[
          SizedBox(height: 4),
          Text(
            'Rates updated ${formatRelativeTime(ratesLastUpdated)}',
            style: ThemeTypography.verySmall.copyWith(
              color: context.themeColors.text60,
            ),
          ),
        ],
        Gap.list,
        ...AnimateList(effects: [
          FadeEffect(curve: Curves.ease),
          MoveEffect(begin: Offset(0.0, 75.0), curve: Curves.fastOutSlowIn)
        ], children: currencies, interval: 80.ms)
            .toList(),
      ],
    );
  }
}
