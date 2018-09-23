import 'package:intl/intl.dart';
import 'package:travelconverter/helpers/sorting.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/screens/add_currency/available_currency_card.dart';
import 'package:travelconverter/screens/add_currency/currency_filter.dart';
import 'package:travelconverter/screens/add_currency/currency_search_text_field.dart';
import 'package:travelconverter/widgets/background_container.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/state_container.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/widgets/screen_title_text.dart';

class AddCurrencyScreen extends StatefulWidget {
  @override
  _AddCurrencyScreenState createState() {
    return new _AddCurrencyScreenState();
  }
}

class _AddCurrencyScreenState extends State<AddCurrencyScreen> {
  List<Currency> currencies;
  CurrencyFilter currencyFilter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // load initial state once
    if (this.currencyFilter == null) {
      final state = StateContainer
          .of(context)
          .appState;

      final appLocalization = AppLocalizations.of(context);
      currencyFilter = new CurrencyFilter(
          state.countries,
          appLocalization
      );
      _filterCurrencies('');
    }
  }

  @override
  Widget build(BuildContext context) {

    final currencyWidgets = this
        .currencies
        .map((currency) => new AvailableCurrencyCard(currency))
        .toList();


    final searchField = new CurrencySearchTextField(
      filterChanged: _filterCurrencies,
    );

    final body = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: currencyWidgets));

    return Scaffold(
        appBar: AppBar(
          title: ScreenTitleText.show(_screenTitle),
          centerTitle: true,
          bottom: new PreferredSize(
            child: searchField,
            preferredSize: const Size.fromHeight(60.0),
          ),
        ),
        body: BackgroundContainer(child: body));
  }

  String get _screenTitle => Intl.message(
    "Add Currency",
    desc: "Add currency screen title."
  );

  _filterCurrencies(String filterText) {
    final state = StateContainer.of(context).appState;
    final allCurrencies = state.availableCurrencies.getList();
    final filteredCurrencies = currencyFilter.getFiltered(allCurrencies, filterText);

    setState((){
      this.currencies = _sorted(filteredCurrencies);
    });
  }

  List<Currency> _sorted(List<Currency> currencies) {
    return alphabeticallySorted<Currency>(
        currencies, (currency) => currency.name);
  }
}
