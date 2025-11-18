import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/widgets/common_card.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/currency_icon.dart';

class CurrencyCard extends StatelessWidget {
  final Function? onTap;
  final String iconName;
  final Widget content;

  const CurrencyCard({
    super.key,
    this.onTap,
    required this.iconName,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Row(
        children: <Widget>[
          CurrencyIcon(iconName: iconName),
          Gap.medium,
          Expanded(child: content),
        ],
      ),
      onTap: onTap,
    );
  }
}
