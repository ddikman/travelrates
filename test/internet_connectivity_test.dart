import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:travelconverter/screens/convert/internet_connectivity.dart';


class MockConnectivity extends Mock implements Connectivity {}

void main() {

  MockConnectivity mockConnectivity;

  StreamController<ConnectivityResult> connectivityStream;

  setUp(() {
    connectivityStream = new StreamController<ConnectivityResult>();
    mockConnectivity = new MockConnectivity();
  });

  tearDown(() {
    if (connectivityStream != null) {
      connectivityStream.close();
    }
  });

  Future<InternetConnectivity> getWithCurrentConnectivity(ConnectivityResult connectivity) {
    when(mockConnectivity.onConnectivityChanged)
      .thenAnswer((_) => connectivityStream.stream);
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) => Future.value(connectivity));

    return InternetConnectivityImpl.withConnectivity(mockConnectivity);
  }

  test("is available after startup if connectivity is mobile", () async {
    var internet = await getWithCurrentConnectivity(ConnectivityResult.mobile);
    expect(internet.isAvailable, true);
  });
}