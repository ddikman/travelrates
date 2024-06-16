import 'package:connectivity/connectivity.dart';
import 'package:travelconverter/app_core/widgets/app_bar_icon.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:travelconverter/screens/convert/selected_currency_list.dart';
import 'package:travelconverter/screens/review_feature/review_storage.dart';
import 'package:travelconverter/screens/review_feature/review_widget.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/widgets/background_container.dart';
import 'package:flutter/material.dart';
import '../../../internet_connectivity.dart';

class ConvertScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      appBarLeftAction: AppBarIcon(
          icon: Icon(Icons.format_list_bulleted_add),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.edit)),
      body: _buildCurrencyList(),
    );
  }

  _buildCurrencyList() {
    const _floatingButtonSpacing = 60.0;

    return new BackgroundContainer(
        key: Key("ConvertScreen"),
        // padding the body bottom stops the floating space button from
        // hiding the lowermost content
        child: new Padding(
          padding: const EdgeInsets.only(bottom: _floatingButtonSpacing),
          child: new Builder(builder: (BuildContext context) {
            return new ReviewWidget(
              child: new SelectedCurrencyList(),
              reviewStorage: new ReviewStorage(
                  new InternetConnectivityImpl(new Connectivity()),
                  new LocalStorage()),
            );
          }),
        ));
  }
}
