import 'package:travelconverter/screens/convert/currency_convert_card.dart';
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

    return new ListView(padding: EdgeInsets.all(8.0), children: currencies);
  }

  Widget _buildCurrencyEntry(
      BuildContext context, int index, String currencyCode) {
    final state = StateContainer.of(context).appState;

    final delayMs = _msDelayBetweenItemAppearance * (index + 1);
    final animationDelay = Duration(milliseconds: delayMs);
    var currency = state.availableCurrencies.getByCode(currencyCode);

    return CurrencyConvertCard(
        key: Key("currencyCard_${currency.code}"),
        currency: currency,
        animationDelay: animationDelay);
  }
}
