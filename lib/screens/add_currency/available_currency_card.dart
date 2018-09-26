import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/screens/add_currency/add_currency_button.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';

class AvailableCurrencyCard extends StatelessWidget {
  final Currency currency;

  AvailableCurrencyCard(this.currency);

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    final localizations = AppLocalizations.of(context);

    final currencyName = localizations.currencies.getLocalized(currency.code);
    Widget textWidget = Text(
      "$currencyName, ${currency.symbol}",
      style: TextStyle(fontSize: 18.0),
    );

    final relatedCountries = state.countries
        .where((country) => country.currencyCode == currency.code)
        .toList();

    if (relatedCountries.length > 1) {
      final countryNames = _groupLocalizedNames(relatedCountries, localizations);
      textWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          textWidget,
          Text(countryNames, style: TextStyle(fontSize: 10.0))
        ],
      );
    }

    final currencyCard = Card(
      color: AppTheme.primaryColor,
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            new Expanded(child: textWidget),
            new AddCurrencyButton(
                key: Key("addCurrency_${currency.code}"),
                currency: currency
            )
          ],
        ),
      ),
    );

    return currencyCard;
  }

  _groupLocalizedNames(List<Country> relatedCountries, AppLocalizations localizations) {
    return relatedCountries.map((country) {
      return localizations.countries.getLocalized(country.name);
    }).join(", ");
  }
}