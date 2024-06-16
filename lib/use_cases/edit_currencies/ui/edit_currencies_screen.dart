import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_core/widgets/title_text.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/screens/convert/add_currency_handler.dart';
import 'package:travelconverter/state_container.dart';
import 'package:travelconverter/use_cases/edit_currencies/ui/select_currency_card.dart';

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
      body: SingleChildScrollView(child: _buildCurrencyList()),
    );
  }

  _buildCurrencyList() {
    final stateContainer = StateContainer.of(context);
    final state = stateContainer.appState;

    final currencies = state.conversion.currencies
        .map(state.availableCurrencies.getByCode)
        .map((currency) => Container(
              key: Key(currency.code),
              color: Colors.transparent,
              child: SelectCurrencyCard(
                currency: currency,
                onTap: () {},
                icon: Icons.low_priority,
              ).pad(bottom: Paddings.listGap),
            ))
        .toList();

    // The ReorderableListView is flutter standard and has a long-press reorder capability
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText('Search currencies'),
        Gap.list,
        ...allCurrencies.map((currency) {
          final isSelected =
              state.conversion.currencies.contains(currency.code);
          final card = SelectCurrencyCard(
              currency: currency,
              icon: isSelected ? Icons.check : Icons.add_circle_outline,
              onTap: () {
                AddCurrencyHandler(currency).addCurrency(context);
              }).pad(bottom: Paddings.listGap);
          return isSelected ? Opacity(opacity: 0.5, child: card) : card;
        }),
        TitleText('Selected currencies'),
        Text('Long press and drag to reorder', style: ThemeTypography.small),
        Gap.list,
        ReorderableListView(
            proxyDecorator: (child, index, animation) => child,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
