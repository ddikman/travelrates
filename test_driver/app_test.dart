import 'dart:async';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Get app screenshots', () {

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

//    test('store ios screenshots', () async {
//      await runTests('ios', driver);
//    });

    test('store android screenshots', () async {
      await runTests('android', driver);
    });
  });
}

Future runTests(String platform, FlutterDriver driver) async {
  print('waiting for search input to appear');
  await driver.waitFor(find.byValueKey('searchCurrencyInput'),
      timeout: Duration(seconds: 45));

  await saveScreen(driver, "${platform}_screen1.png");
  await driver.enterText('British');
  await saveScreen(driver, '${platform}_screen2.png');
  await driver.tap(find.byValueKey('addCurrency_GBP'));

  await driver.tap(find.byValueKey('addCurrencyButton'));
  await driver.waitFor(find.byValueKey('searchCurrencyInput'));
  await driver.enterText('Eur');
  await driver.tap(find.byValueKey('addCurrency_EUR'));

  await driver.tap(find.byValueKey('addCurrencyButton'));
  await driver.waitFor(find.byValueKey('searchCurrencyInput'));
  await driver.enterText('Japan');
  await driver.tap(find.byValueKey('addCurrency_JPY'));

  await saveScreen(driver, "${platform}_screen3.png");
  await driver.tap(find.byValueKey('currencyCard_EUR'));

  await driver.tap(find.byValueKey("convertTextField"));
  await driver.enterText('300');
  await saveScreen(driver, "${platform}_screen4.png");

  await driver.tap(find.byValueKey('convertButton'));
  await saveScreen(driver, "${platform}_screen5.png");
}

Future directoryExists(String name) async {
  return await new Directory("screenshots").exists();
}

Future saveScreen(FlutterDriver driver, String name) async {
  print("saving screenshot $name");
  driver.waitUntilNoTransientCallbacks(timeout: new Duration(seconds: 5));
  final screenshot = await driver.screenshot();
  final directory = new Directory("screenshots");
  if (!(await directory.exists())) {
    await directory.create();
  }
  var file = new File("screenshots/$name");
  await file.writeAsBytes(screenshot);
  print("screenshot $name saved");
}