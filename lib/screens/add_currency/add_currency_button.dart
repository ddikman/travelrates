import 'package:intl/intl.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/screens/convert/add_currency_handler.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';

class AddCurrencyButton extends StatelessWidget {

  final Currency currency;

  final GestureTapCallback onTap;

  const AddCurrencyButton({Key key, this.currency, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final alreadyAdded = StateContainer.of(context).appState
        .conversion.currencies.contains(currency.code);
    final disabledTransparency = alreadyAdded ? 0.5 : 1.0;

    return new GestureDetector(
      child: Icon(
        Icons.add_circle,
        size: 32.0,
        color: Color.fromRGBO(255, 255, 255, disabledTransparency),
      ),
      onTap: onTap,
    );
  }
}