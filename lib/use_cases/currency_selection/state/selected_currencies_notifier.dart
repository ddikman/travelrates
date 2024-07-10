import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/state_container.dart';

final selectedCurrenciesNotifierProvider =
    NotifierProvider<SelectedCurrenciesNotifier, List<Currency>>(() {
  return SelectedCurrenciesNotifier();
});

class SelectedCurrenciesNotifier extends Notifier<List<Currency>> {
  @override
  List<Currency> build() {
    final appState = ref.read(appStateProvider);
    return _getCurrencies(appState);
  }

  void removeCurrency(String currencyCode) {
    final stateContainer = ref.read(stateContainerProvider);
    stateContainer.removeCurrency(currencyCode);
    state = _getCurrencies(stateContainer.appState);
  }

  List<Currency> _getCurrencies(AppState state) {
    return state.conversion.currencies
        .map((code) => state.availableCurrencies.getByCode(code))
        .toList();
  }

  move({required Currency item, required int newIndex}) {
    final stateContainer = ref.read(stateContainerProvider);
    stateContainer.reorderCurrency(item: item.code, newIndex: newIndex);
    state = _getCurrencies(stateContainer.appState);
  }

  void add(String code) {
    final stateContainer = ref.read(stateContainerProvider);
    stateContainer.addCurrency(code);
    state = _getCurrencies(stateContainer.appState);
  }
}
