
import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/screens/convert/currency_convert_card.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SelectedCurrencyList extends StatelessWidget {
  static const int _msDelayBetweenItemAppearance = 60;

  @override
  Widget build(BuildContext context) {
    final state = StateContainer
        .of(context)
        .appState;

    int index = 0;
    final currencies = state.conversion.currencies
        .map((currency) => _buildCurrencyEntry(context, index++, currency))
        .toList();

    return new ListView(
        padding: EdgeInsets.all(8.0),
        children: currencies
    );
  }

  Widget _buildCurrencyEntry(BuildContext context, int index, String currencyCode) {
    final state = StateContainer
        .of(context)
        .appState;

    final animationDelay =
    Duration(milliseconds: _msDelayBetweenItemAppearance * (index + 1));
    var currency = state.availableCurrencies.getByCode(currencyCode);
    final card = CurrencyConvertCard(
        currency: currency,
        animationDelay: animationDelay);

    return _withReorderDropArea(card, context);
  }

  Widget _withReorderDropArea(CurrencyConvertCard card, BuildContext context) {
    final dropArea = new Align(
      alignment: Alignment.bottomCenter,
      child: new DragTarget<Currency>(
        builder: (BuildContext context, List candidateData, List rejectedData) {
          bool hovered = candidateData.isNotEmpty;
          return _dropTargetArea(hovered, context);
        },
        onAccept: (value) {
          // handle the reorder. since we dropped the other card on this card
          // it means we want to place it _after_ this card
          StateContainer
              .of(context)
              .reorder(item: value.code, placeAfter: card.currency.code);
        },
        onWillAccept: (value) => value.code != card.currency.code,
      ),
    );

    return Stack(
      children: <Widget>[card, dropArea],
    );
  }

  Widget _dropTargetArea(bool hovered, BuildContext context) {
    const iconSize = 24.0;

    final dropAreaHeight = hovered
        ? (CurrencyConvertCard.height + iconSize)
        : CurrencyConvertCard.height;

    return new FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        height: dropAreaHeight,
        alignment: Alignment.bottomCenter,
        child: Opacity(
          opacity: hovered ? 1.0 : 0.0,
          child: Icon(
            Icons.add_circle,
            color: AppTheme.primaryColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}