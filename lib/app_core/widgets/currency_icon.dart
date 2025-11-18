import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';

/// Widget that displays a currency icon, which can be either:
/// - A country flag (for most currencies)
/// - A local asset file (for special currencies like EUR, BTC, etc.)
class CurrencyIcon extends StatelessWidget {
  /// Icon names that use local asset files instead of the country_flags package
  static const Set<String> overrideAssetIcons = {
    'XPF',
    'XSD',
    'BTC',
    'EUR',
    'ANG'
  };

  /// The icon name from the currency data (can be a country code or currency code)
  final String iconName;

  /// The size of the icon
  final double size;

  const CurrencyIcon({
    super.key,
    required this.iconName,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: hasOverrideAssetIcon(iconName)
          ? ClipOval(
              child: Image.asset(
                getLocalAssetPath(iconName),
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            )
          : CountryFlag.fromCountryCode(
              iconName,
              theme: const ImageTheme(
                shape: Circle(),
              ),
            ),
    );
  }

  /// Determines if an icon name should use a local asset file instead of a country flag
  @visibleForTesting
  static bool hasOverrideAssetIcon(String iconName) {
    return overrideAssetIcons.contains(iconName.toUpperCase());
  }

  /// Gets the asset path for a local icon asset
  @visibleForTesting
  static String getLocalAssetPath(String iconName) {
    return 'assets/flags/$iconName.png';
  }
}
