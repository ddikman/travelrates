import 'package:travelconverter/model/async_result.dart';
import 'package:test/test.dart';

void main() {
  test('when getting result of failed async operation, throws state error', () {
    final failed = AsyncResult<String>.failed();
    expect(() => failed.result, throwsA(isInstanceOf<StateError>()));
  });

  test('can get result on successful result', () {
    final success = AsyncResult.withValue('success!');
    expect(success.result, 'success!');
    expect(success.successful, true);
  });
}
