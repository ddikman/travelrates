import 'package:travelconverter/screens/convert/internet_connectivity.dart';

class MockInternetConnectivity implements InternetConnectivity {
  bool _isAvailable = true;

  void setAvailable(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  @override
  bool get isAvailable => _isAvailable;
}