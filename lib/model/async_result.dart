/// Describes the result of an async operation that could fail, returning null.
/// The idea is that whilst a failing future can contain an error which can be ignored
/// this class explicitly tells the caller that the error has been handled gracefully and
/// can be ignored, simply that no result is available at this time.
class AsyncResult<T> {
  final T? _result;

  final bool successful;

  AsyncResult.failed()
      : this._result = null,
        this.successful = false;

  AsyncResult.withValue(T result)
      : this._result = result,
        this.successful = true;

  T? get result {
    if (!successful) {
      throw StateError(
          'Async operation was not successful. Ensure .successful is called before attempting to call this getter.');
    }

    return _result;
  }
}
