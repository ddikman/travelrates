import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/widgets/common_card.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';

class CurrencyCard extends StatelessWidget {
  final Function? onTap;
  final String currencyIconName;
  final Widget content;

  const CurrencyCard(
      {super.key,
      this.onTap,
      required this.currencyIconName,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/flags/$currencyIconName.png',
              width: 32.0,
              height: 32.0,
            ),
            Gap.medium,
            Expanded(child: content),
          ],
        ),
        onTap: onTap);
  }
}
