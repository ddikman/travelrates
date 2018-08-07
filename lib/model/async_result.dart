/// Describes the result of an async operation that could fail, returning null.
class AsyncResult<T> {
  final T _result;

  final bool successful;

  AsyncResult.failed()
      : this._result = null,
        this.successful = false;

  AsyncResult.withValue(T result)
      : this._result = result,
        this.successful = true;

  T get result {
    if (!successful) {
      throw StateError(
          'Async operation was not successful. Ensure .successful is called before attempting to call this getter.');
    }

    return _result;
  }
}
