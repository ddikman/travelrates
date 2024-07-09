import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_core/widgets/title_text.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/use_cases/home/services/add_currency_handler.dart';
import 'package:travelconverter/state_container.dart';
import 'package:travelconverter/use_cases/edit_currencies/services/currency_filter.dart';
import 'package:travelconverter/use_cases/edit_currencies/ui/search_input.dart';
import 'package:travelconverter/use_cases/edit_currencies/ui/select_currency_card.dart';

class EditCurrenciesScreen extends StatefulWidget {
  @override
  EditCurrenciesScreenState createState() {
    return new EditCurrenciesScreenState();
  }
}

class EditCurrenciesScreenState extends State<EditCurrenciesScreen> {
  List<Currency> allCurrencies = [];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final state = StateContainer.of(context).appState;
    setState(() {
      allCurrencies = state.availableCurrencies.getList();
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

    final localization = AppLocalizations.of(context);
    final selectedCurrencies = state.conversion.currencies
        .map(state.availableCurrencies.getByCode)
        .map((currency) => Container(
              key: Key(currency.code),
              color: Colors.transparent,
              child: Dismissible(
                  key: Key(currency.code),
                  onDismissed: (direction) {
                    stateContainer.removeCurrency(currency.code);
                  },
                  child: SelectCurrencyCard(
                    currency: currency,
                    onTap: () {},
                    icon: Icons.low_priority,
                    iconColor: lightTheme.accent,
                  )).pad(bottom: Paddings.listGap),
            ))
        .toList();

    final filter = CurrencyFilter(state.countries, localization);

    // The ReorderableListView is flutter standard and has a long-press reorder capability
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText('Add currency'),
        Text(
            'Search for currencies to add by name, country of use or currency code',
            style: ThemeTypography.small),
        Gap.list,
        SearchInput(
          autoFocus: selectedCurrencies.length < 2,
          onChange: (value) => setState(() => searchQuery = value),
        ),
        Gap.list,
        if (searchQuery.isNotEmpty || selectedCurrencies.length < 3)
          ...filter.getFiltered(allCurrencies, searchQuery).map((currency) {
            return SearchCurrencyResultEntry(
                currency: currency,
                isSelected: state.conversion.currencies.contains(currency.code),
                onTap: () => AddCurrencyHandler(currency).addCurrency(context));
          }),
        if (selectedCurrencies.isNotEmpty) ...[
          Gap.list,
          TitleText('Selected currencies'),
          Text('Long press and drag to reorder', style: ThemeTypography.small),
          Gap.list,
          ReorderableListView(
              proxyDecorator: (child, index, animation) => child,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: selectedCurrencies,
              onReorder: _reorderListEntry),
        ]
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

class SearchCurrencyResultEntry extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final Function onTap;

  SearchCurrencyResultEntry(
      {required this.currency, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final card = SelectCurrencyCard(
        currency: currency,
        icon: isSelected ? Icons.check : Icons.add_circle_outline,
        iconColor: isSelected ? lightTheme.green : lightTheme.accent,
        onTap: () {
          AddCurrencyHandler(currency).addCurrency(context);
        }).pad(bottom: Paddings.listGap);
    return isSelected ? Opacity(opacity: 0.5, child: card) : card;
  }
}
