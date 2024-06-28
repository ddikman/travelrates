import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/currency_card.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/state_container.dart';

class SelectCurrencyCard extends StatelessWidget {
  final Currency currency;
  final Function onTap;
  final IconData icon;
  final Color iconColor;

  const SelectCurrencyCard(
      {super.key,
      required this.currency,
      required this.onTap,
      required this.icon,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    final state = StateContainer.of(context).appState;
    final relatedCountries = state.countries
        .where((country) => country.currencyCode == currency.code)
        .toList();

    final countryNames = _groupLocalizedNames(relatedCountries, localization);

    return CurrencyCard(
        onTap: onTap,
        currencyIconName: currency.icon,
        content:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${localization.currencies.getLocalized(currency.code)}, ${currency.code}",
                      style: ThemeTypography.small.bold),
                  Text("Used in countries like: ${countryNames}",
                      style: ThemeTypography.verySmall)
                ]),
          ),
          Gap.medium,
          Icon(icon, color: iconColor, size: 24.0)
        ]));
  }

  _groupLocalizedNames(
      List<Country> relatedCountries, AppLocalizations localizations) {
    return relatedCountries.map((country) {
      return localizations.countries.getLocalized(country.name);
    }).join(", ");
  }
}
