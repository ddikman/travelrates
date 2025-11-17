import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/widgets/common_card.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/helpers/flag_helper.dart';
import 'package:country_flags/country_flags.dart';

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
            SizedBox(
              width: 32.0,
              height: 32.0,
              child: FlagHelper.shouldUseLocalAsset(currencyIconName)
                  ? ClipOval(
                      child: Image.asset(
                        FlagHelper.getLocalAssetPath(currencyIconName),
                        width: 32.0,
                        height: 32.0,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CountryFlag.fromCountryCode(
                      currencyIconName,
                      theme: const ImageTheme(
                        shape: Circle(),
                      ),
                    ),
            ),
            Gap.medium,
            Expanded(child: content),
          ],
        ),
        onTap: onTap);
  }
}
