import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_state.dart';

final availableCurrenciesProvider = Provider((ref) {
  final state = ref.watch(appStateProvider);
  return state.availableCurrencies.getList();
});
