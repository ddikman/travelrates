import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:travelconverter/screens/convert/internet_connectivity.dart';


class MockConnectivity extends Mock implements Connectivity {}

void main() {

  MockConnectivity mockConnectivity;
  StreamController<ConnectivityResult> connectivityStream;
  Future<ConnectivityResult> connectivityResult;

  setUp(() {
    connectivityStream = new StreamController<ConnectivityResult>(sync: true);
    mockConnectivity = new MockConnectivity();
  });

  tearDown(() {
    if (connectivityStream != null) {
      connectivityStream.close();
    }
  });

  InternetConnectivity getWithCurrentConnectivity(ConnectivityResult connectivity) {
    connectivityResult = Future.value(connectivity);
    when(mockConnectivity.onConnectivityChanged)
      .thenAnswer((_) => connectivityStream.stream);
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) => connectivityResult);

    return new InternetConnectivityImpl(mockConnectivity);
  }

  test("is available after startup if connectivity is mobile", () async {
    var internet = getWithCurrentConnectivity(ConnectivityResult.mobile);
    await connectivityResult;
    expect(internet.isAvailable, true);
  });

  test("is available after startup if connectivity is wifi", () async {
    var internet = getWithCurrentConnectivity(ConnectivityResult.wifi);
    await connectivityResult;
    expect(internet.isAvailable, true);
  });

  test("is unavailable after startup if connectivity is none", () async {
    var internet = getWithCurrentConnectivity(ConnectivityResult.none);
    await connectivityResult;
    expect(internet.isAvailable, false);
  });

  test("becomes available when connectivity changes", () async {
    var internet = getWithCurrentConnectivity(ConnectivityResult.none);
    await connectivityResult;
    expect(internet.isAvailable, false);

    connectivityStream.add(ConnectivityResult.mobile);
    expect(internet.isAvailable, true);
  });
}