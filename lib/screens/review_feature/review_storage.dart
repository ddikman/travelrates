import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:travelconverter/internet_connectivity.dart';
import 'package:travelconverter/screens/review_feature/review_rule.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';

class ReviewStorageModel {
  int conversionsDone;
  int conversionsRequired;
  bool submitted;

  ReviewStorageModel({this.conversionsDone, this.conversionsRequired, this.submitted});
}

class ReviewStorage {

  static final Logger _log = new Logger<ReviewStorage>();
  
  static const String _resourceName = "reviews.json";

  final LocalStorage _localStorage;

  ReviewStorage(this._localStorage);

  ReviewRule _parse(String json) {
    ReviewStorageModel reviews = new JsonDecoder().convert(json);
    return new ReviewRule(
      internet: new InternetConnectivityImpl(new Connectivity()),
      conversionsRequired: reviews.conversionsRequired,
      conversionsDone: reviews.conversionsDone,
      submitted: reviews.submitted,
    );
  }

  Future<ReviewRule> read() async {
    var reviewsFile = await _localStorage.getFile(_resourceName);
    if (await reviewsFile.exists) {
      var json = await reviewsFile.contents;
      var review = _parse(json);
      _log.debug("Loaded review data from file");
      return review;
    }

    _log.debug("Created new review data");
    return new ReviewRule(
        internet: new InternetConnectivityImpl(new Connectivity()),
        conversionsRequired: 5,
        conversionsDone: 0,
        submitted: false
    );
  }

  String _encode(ReviewRule rule) {
    var model = new ReviewStorageModel(
      conversionsDone: rule.conversionsDone,
      conversionsRequired: rule.conversionsRequired,
      submitted: rule.submitted
    );
    return new JsonEncoder().convert(model);
  }

  Future<void> save(ReviewRule reviewRule) async {
    var reviewsFile = await _localStorage.getFile(_resourceName);
    await reviewsFile.writeContents(_encode(reviewRule));
  }
}