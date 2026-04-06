/// Maps legacy/deprecated currency codes to their modern replacements.
///
/// Some currencies have been replaced by newer versions (e.g. VEF → VES,
/// MRO → MRU). Users who had these legacy codes saved in their preferences
/// need them mapped to the current codes on load.
class LegacyCurrencyMapper {
  static const Map<String, String> _legacyMappings = {
    'VEF': 'VES', // Venezuelan Bolívar → Bolívar Soberano (2018)
    'MRO': 'MRU', // Mauritanian Ouguiya old → new (2018)
  };

  /// Returns the modern currency code for a given code.
  /// If the code is not a legacy code, it is returned unchanged.
  static String mapCode(String code) {
    return _legacyMappings[code.toUpperCase()] ?? code.toUpperCase();
  }

  /// Maps all currency codes in a list, replacing any legacy codes.
  static List<String> mapCodes(List<String> codes) {
    return codes.map(mapCode).toList();
  }
}
