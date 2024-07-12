import 'package:connectivity/connectivity.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconverter/app_core/config.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';
import 'package:travelconverter/app_core/widgets/app_bar_icon.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/routing/routes.dart';
import 'package:travelconverter/use_cases/home/ui/convertible_currencies_list.dart';
import 'package:travelconverter/use_cases/home/ui/home_screen_animation.dart';
import 'package:travelconverter/use_cases/review_feature/review_storage.dart';
import 'package:travelconverter/use_cases/review_feature/review_widget.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:flutter/material.dart';
import '../../../internet_connectivity.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.themeColors.background,
      child: Column(
        children: [
          Expanded(
            child: Stack(children: [
              if (!isTesting)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: HomeScreenAnimation()),
              PageScaffold(
                transparent: true,
                appBarLeftAction: AppBarIcon(
                    icon: Icon(Icons.help_outline),
                    onTap: () => context.push(Routes.about)),
                appBarRightAction: AppBarIcon(
                    icon: Icon(Icons.format_list_bulleted_add),
                    onTap: () => context.push(Routes.edit)),
                body: _buildCurrencyList().pad(
                    bottom:
                        260.0), // padding to allow scrolling to see bottom animation
              )
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyList() {
    return Builder(builder: (BuildContext context) {
      return ReviewWidget(
        child: ConvertibleCurrenciesList(),
        reviewStorage: ReviewStorage(
            InternetConnectivityImpl(Connectivity()), LocalStorage()),
      );
    });
  }
}
