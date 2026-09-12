import 'package:flutter/foundation.dart';
import 'package:travelconverter/services/crash_reporter.dart';

/// Local logging with opt-in non-fatal error forwarding in release builds.
class Logger<T> {
  final String name = T.toString();

  void _log(String eventType, String message) {
    debugPrint("$name:$eventType: $message");
  }

  void debug(String message) {
    _log('Debug', message);
  }

  void error(String message, {StackTrace? stackTrace}) {
    _log('Error', "$message\n$stackTrace");
  }

  /// Reports only genuinely unexpected caught exceptions to Crashlytics.
  /// Callers must not include currency amounts, user behavior, or expected
  /// offline/network failures in [reason].
  void unexpected(Object error, StackTrace stackTrace, {String? reason}) {
    _log('Error', '${reason ?? error}\n$stackTrace');
    CrashReporter.recordNonFatal(
      error,
      stackTrace,
      reason: reason == null ? name : '$name: $reason',
    );
  }
}
