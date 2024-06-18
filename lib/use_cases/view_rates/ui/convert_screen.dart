import 'package:connectivity/connectivity.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/widgets/app_bar_icon.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:travelconverter/screens/convert/selected_currency_list.dart';
import 'package:travelconverter/screens/review_feature/review_storage.dart';
import 'package:travelconverter/screens/review_feature/review_widget.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:flutter/material.dart';
import '../../../internet_connectivity.dart';

class ConvertScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightTheme.background,
      child: Column(
        children: [
          Expanded(
            child: Stack(children: [
              RiveAnimation.asset('assets/animations/tokyo-skyline.riv',
                  fit: BoxFit.fitWidth,
                  controllers: [SimpleAnimation('Scroll')],
                  alignment: Alignment.bottomCenter),
              PageScaffold(
                transparent: true,
                appBarLeftAction: AppBarIcon(
                    icon: Icon(Icons.format_list_bulleted_add),
                    onTap: () => context.push(AppRoutes.edit)),
                body: _buildCurrencyList(),
              )
            ]),
          ),
        ],
      ),
    );
  }

  _buildCurrencyList() {
    return Builder(builder: (BuildContext context) {
      return ReviewWidget(
        child: SelectedCurrencyList(),
        reviewStorage: ReviewStorage(
            InternetConnectivityImpl(Connectivity()), LocalStorage()),
      );
    });
  }
}
