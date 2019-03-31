import 'package:flutter_driver/flutter_driver.dart';
import 'package:test_api/test_api.dart';

void main() {
  group('Startup Performance', () {
    FlutterDriver driver;

    DateTime timestamp;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      timestamp = DateTime.now();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('measure time for first screen to load', () async {
      final listFinder = find.byValueKey('ConvertScreen');
      await driver.waitFor(listFinder);

      final totalTime = DateTime.now().difference(timestamp);
      print(totalTime.inMilliseconds);
    });
  });
}