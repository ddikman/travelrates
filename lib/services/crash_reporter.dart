import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Initializes minimal crash reporting without enabling usage analytics.
///
/// Crash reporting is release-only. Initialization is deliberately fail-open:
/// an unavailable Firebase service must never stop TravelRates from starting.
class CrashReporter {
  CrashReporter._();

  static bool _enabled = false;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );

      if (!kReleaseMode) return;

      _enabled = true;
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
        );
        return true;
      };
    } catch (error, stackTrace) {
      debugPrint('Crash reporting unavailable: $error\n$stackTrace');
    }
  }

  static void recordNonFatal(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) {
    if (!_enabled) return;
    unawaited(
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: false,
      ),
    );
  }
}
