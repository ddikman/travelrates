/// Helper functions for determining flag asset sources
class FlagHelper {
  /// Country codes that use local asset files instead of the country_flags package
  static const Set<String> localAssetFlags = {'XPF', 'XCD', 'BTC', 'EUR'};

  /// Determines if a country code should use a local asset file
  ///
  /// Returns true if the code is in the localAssetFlags set
  static bool shouldUseLocalAsset(String countryCode) {
    return localAssetFlags.contains(countryCode.toUpperCase());
  }

  /// Gets the asset path for a local flag asset
  ///
  /// Returns the path to the flag asset in assets/flags/
  static String getLocalAssetPath(String countryCode) {
    return 'assets/flags/$countryCode.png';
  }
}
