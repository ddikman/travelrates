import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  String read(String path) => File(path).readAsStringSync();

  test('Crashlytics replaces Analytics in app dependencies', () {
    final pubspec = read('pubspec.yaml');
    expect(pubspec, contains('firebase_crashlytics:'));
    expect(pubspec, isNot(contains('firebase_analytics:')));

    final dartSources = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .map((file) => file.readAsStringSync())
        .join('\n');
    expect(dartSources, isNot(contains('FirebaseAnalytics')));
    expect(dartSources, isNot(contains('log.event(')));
  });

  test(
    'production symbol upload and release-only collection are configured',
    () {
      final androidSettings = read('android/settings.gradle');
      final androidApp = read('android/app/build.gradle');
      final xcodeProject = read('ios/Runner.xcodeproj/project.pbxproj');
      final crashReporter = read('lib/services/crash_reporter.dart');

      expect(androidSettings, contains('com.google.firebase.crashlytics'));
      expect(androidApp, contains("id 'com.google.firebase.crashlytics'"));
      expect(xcodeProject, contains('FirebaseCrashlytics/run'));
      expect(xcodeProject, contains('DWARF_DSYM_FOLDER_PATH'));
      expect(crashReporter, contains('setCrashlyticsCollectionEnabled('));
      expect(crashReporter, contains('kReleaseMode'));
    },
  );

  test('French is included in the released iOS localization regions', () {
    final infoPlist = read('ios/Runner/Info.plist');
    final xcodeProject = read('ios/Runner.xcodeproj/project.pbxproj');

    expect(infoPlist, contains('<string>fr</string>'));
    expect(xcodeProject, contains('fr.lproj/Main.strings'));
    expect(xcodeProject, contains('fr.lproj/LaunchScreen.strings'));
  });
}
