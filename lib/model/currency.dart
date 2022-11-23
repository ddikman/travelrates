class Currency {
  final String symbol;

  final String icon;

  final String name;

  final String code;

  double rate;

  Currency(
      {required this.symbol,
      required this.name,
      required this.code,
      required this.icon,
      required this.rate});

  @override
  String toString() {
    return "$name, $symbol";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          symbol == other.symbol &&
          icon == other.icon &&
          name == other.name &&
          code == other.code &&
          rate == other.rate;

  @override
  int get hashCode =>
      symbol.hashCode ^
      icon.hashCode ^
      name.hashCode ^
      code.hashCode ^
      rate.hashCode;
}
