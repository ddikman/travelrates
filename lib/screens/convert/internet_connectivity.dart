import 'package:connectivity/connectivity.dart';

abstract class InternetConnectivity {
  bool get isAvailable => null;
}

class InternetConnectivityImpl implements InternetConnectivity {
  final Connectivity _connectivity;

  bool _isAvailable = false;

  static Future<InternetConnectivityImpl> withConnectivity(Connectivity connectivity) async {
    var result = await connectivity.checkConnectivity();
    var available = _isResultAvailable(result);
    return new InternetConnectivityImpl._create(connectivity, available);
  }

  static bool _isResultAvailable(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  InternetConnectivityImpl._create(Connectivity connectivity, bool isAvailable) : _connectivity = connectivity {
    _isAvailable = isAvailable;
    _connectivity.onConnectivityChanged.listen(_updateConnectivity);
  }

  _updateConnectivity(ConnectivityResult connectivity) {
    _isAvailable = _isResultAvailable(connectivity);
  }

  @override
  bool get isAvailable => _isAvailable;
}