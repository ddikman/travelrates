import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_state.dart';

final selectedCurrenciesProvider = Provider((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.conversion.currencies
      .map((code) => appState.availableCurrencies.getByCode(code))
      .toList();
});
