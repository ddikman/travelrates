import 'package:travelconverter/screens/convert/internet_connectivity.dart';

abstract class Reviews {
  void conversionDone();
  void reviewSubmitted();
  void reviewDeclined();
}

abstract class ReviewsSubmitted implements Reviews {}


class ReviewsImpl implements Reviews {
  final Function onReviewRequested;

  int _conversionsDone = 0;
  int _conversionsRequired = 0;
  bool _submitted = false;

  InternetConnectivity _internet;

  ReviewsImpl({int conversionsDone, int conversionsRequired, InternetConnectivity internetConnectivity, this.onReviewRequested}) {
    this._conversionsDone = conversionsDone;
    this._conversionsRequired = conversionsRequired ?? 5;
    this._internet = internetConnectivity;
  }

  int get conversionsDone => _conversionsDone;
  int get conversionsRequired => _conversionsRequired;

  bool get isSubmitted => _submitted;

  conversionDone() {
    _conversionsDone++;
    if (_conversionsDone >= _conversionsRequired && _internet.isAvailable && onReviewRequested != null) {
        onReviewRequested();
    }
  }

  reviewSubmitted() {
    _submitted = true;
  }

  reviewDeclined() {
    _conversionsRequired = _conversionsRequired * 2;
  }
}