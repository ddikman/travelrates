import 'package:travelconverter/internet_connectivity.dart';

class MockInternetConnectivity implements InternetConnectivity {
  bool _isAvailable = true;

  void setAvailable(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<void> pollConnectivity() {
    return Future.value(null);
  }
}
