import 'package:firebase_analytics/firebase_analytics.dart';

/// Wrapper for logging enabling use of services such as Firebase in the future.
class Logger<T> {
  static FirebaseAnalytics? analytics;

  /// This doesn't actually work so I might as well change it to a string.
  final String name = T.runtimeType.toString();

  void _log(String eventType, String message) {
    print("$name:$eventType: $message");
  }

  void event(String name, String message, {Map<String, Object>? parameters}) {
    _log('Event', message);

    parameters = parameters ?? Map<String, Object>();
    parameters['message'] = message;
    analytics?.logEvent(name: name, parameters: parameters);
  }

  void debug(String message) {
    _log('Debug', message);
  }

  void error(String message) {
    _log('Error', message);
  }
}
