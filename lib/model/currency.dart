
class Currency {
  final String symbol;

  final String icon;

  final String name;

  final String code;

  final double rate;

  Currency({this.symbol, this.name, this.code, this.icon, this.rate});

  @override
  String toString() {
    return "$name, $symbol";
  }
}