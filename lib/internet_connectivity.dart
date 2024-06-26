import 'package:connectivity/connectivity.dart';

abstract class InternetConnectivity {
  bool get isAvailable => false;

  Future<void> pollConnectivity();
}

class InternetConnectivityImpl implements InternetConnectivity {
  final Connectivity _connectivity;

  bool _isAvailable = false;

  InternetConnectivityImpl(Connectivity connectivity)
      : _connectivity = connectivity {
    _connectivity.checkConnectivity().then(_updateConnectivity);
    connectivity.onConnectivityChanged.listen(_updateConnectivity);
  }

  _updateConnectivity(ConnectivityResult connectivity) {
    print('Connectivity changed to $connectivity');
    _isAvailable = connectivity != ConnectivityResult.none;
  }

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<void> pollConnectivity() async {
    await _connectivity.checkConnectivity().then(_updateConnectivity);
  }
}
