import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_core/widgets/title_text.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/screens/edit_screen/edit_screen_list_entry.dart';
import 'package:travelconverter/state_container.dart';

class EditCurrenciesScreen extends StatefulWidget {
  @override
  EditCurrenciesScreenState createState() {
    return new EditCurrenciesScreenState();
  }
}

class EditCurrenciesScreenState extends State<EditCurrenciesScreen> {
  List<Currency> allCurrencies = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final state = StateContainer.of(context).appState;
    setState(() {
      allCurrencies = state.availableCurrencies.getList().take(10).toList();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      body: _buildCurrencyList(),
    );
  }

  _buildCurrencyList() {
    final stateContainer = StateContainer.of(context);
    final state = stateContainer.appState;

    final currencies = state.conversion.currencies
        .map(state.availableCurrencies.getByCode)
        .map((currency) => new EditScreenListEntry(
            key: Key(currency.code), currency: currency))
        .toList();

    // The ReorderableListView is flutter standard and has a long-press reorder capability
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText('Search currencies'),
        Gap.list,
        ...allCurrencies
            .map((currency) => Text(currency.name).pad(bottom: 4.0)),
        TitleText('Selected currencies'),
        Gap.list,
        ReorderableListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 4.0),
            children: currencies,
            onReorder: _reorderListEntry),
      ],
    );
  }

  void _reorderListEntry(int oldIndex, int newIndex) {
    final stateContainer = StateContainer.of(context);
    final state = stateContainer.appState;

    var moveCurrency = state.conversion.currencies.elementAt(oldIndex);
    stateContainer.reorderCurrency(item: moveCurrency, newIndex: newIndex);
  }
}
