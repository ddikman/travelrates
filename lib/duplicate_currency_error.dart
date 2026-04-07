class DuplicateCurrencyError extends Error {
  final Object? message;
  DuplicateCurrencyError([this.message]);
  @override
  String toString() => message?.toString() ?? '';
}
