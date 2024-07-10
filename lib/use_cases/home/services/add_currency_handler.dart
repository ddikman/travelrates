import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/app_core/widgets/app_snack_bar.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/use_cases/currency_selection/state/selected_currencies_notifier.dart';

class AddCurrencyHandler {
  static final log = new Logger<AddCurrencyHandler>();

  final Currency currency;
  final SelectedCurrenciesNotifier selectedCurrenciesNotifier;

  AddCurrencyHandler(this.currency, this.selectedCurrenciesNotifier);

  _displayNotice(BuildContext context) {
    log.event('currencyAlreadyAdded',
        "${currency.name} already added, showing snack instead",
        parameters: {'currency': currency.name});

    final localizations = AppLocalizations.of(context);
    var currencyLocalizedName =
        localizations.currencies.getLocalized(currency.code);

    AppSnackBar.showError(
        context, _alreadySelectedWarning(currencyLocalizedName));
  }

  addCurrency(BuildContext context) {
    try {
      selectedCurrenciesNotifier.add(currency.code);

      // return to previous screen
      context.pop();
      // ignore: non_constant_identifier_names
    } catch (DuplicateCurrencyError) {
      _displayNotice(context);
    }
  }

  String _alreadySelectedWarning(String currencyName) {
    return Intl.message("$currencyName is already selected!",
        name: "_alreadySelectedWarning",
        desc:
            "Text displayed when trying to add a currency that is already added.",
        args: [currencyName]);
  }
}
