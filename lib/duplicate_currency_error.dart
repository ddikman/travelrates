class DuplicateCurrencyError extends Error {
  final Object message;
  DuplicateCurrencyError([this.message]);
  String toString() => this.message;
}