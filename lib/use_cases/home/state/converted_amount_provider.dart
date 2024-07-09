import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/currency.dart';

final convertedAmountProvider =
    Provider.family<double, Currency>((ref, currency) {
  final appState = ref.watch(appStateProvider);
  return appState.conversion.getAmountInCurrency(currency);
});
