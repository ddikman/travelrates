
class Currency {
  final String symbol;

  final String icon;

  final String name;

  final String code;

  double rate;

  Currency({this.symbol, this.name, this.code, this.icon, this.rate}) {
    if (symbol == null) ArgumentError.notNull('symbol');
    if (name == null) ArgumentError.notNull('name');
    if (code == null) ArgumentError.notNull('code');
    if (icon == null) ArgumentError.notNull('icon');
    if (rate == null) ArgumentError.notNull('rate');
  }

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