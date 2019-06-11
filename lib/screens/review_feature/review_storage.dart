import 'package:travelconverter/internet_connectivity.dart';
import 'package:travelconverter/screens/review_feature/review_rule.dart';
import 'package:travelconverter/screens/review_feature/review_storage_model.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';

class ReviewStorage {

  static final Logger _log = new Logger<ReviewStorage>();
  
  static const String _resourceName = "reviews.json";

  final LocalStorage _localStorage;
  final InternetConnectivity _connectivity;

  ReviewStorage(this._connectivity, this._localStorage);
  
  ReviewRule _createDefaultReviewRule(InternetConnectivity internet) {
    _log.debug("Creating new review data");
    return new ReviewRule(
      internet: internet,
      conversionsDone: 0,
      conversionsRequired: 5,
      submitted: false
    );
  }

  ReviewRule _parse(String json) {
    try {
      var reviews = ReviewStorageModel.fromJson(json);
      return new ReviewRule(
        internet: _connectivity,
        conversionsRequired: reviews.conversionsRequired,
        conversionsDone: reviews.conversionsDone,
        submitted: reviews.submitted,
      );
    } on Exception catch (ex) {
      _log.error("Error when trying to parse review json, will reset: " + ex.toString());
      return _createDefaultReviewRule(_connectivity);
    }
    
  }

  Future<ReviewRule> read() async {
    var reviewsFile = await _localStorage.getFile(_resourceName);
    if (await reviewsFile.exists) {
      var json = await reviewsFile.contents;
      var review = _parse(json);
      _log.debug("Loaded review data from file");
      _log.debug("Review submitted = ${review.submitted}, ${review.conversionsDone} conversions done");
      return review;
    }
    
    return _createDefaultReviewRule(_connectivity);
  }

  String _encode(ReviewRule rule) {
    var model = new ReviewStorageModel(
      conversionsDone: rule.conversionsDone,
      conversionsRequired: rule.conversionsRequired,
      submitted: rule.submitted
    );
    return model.toJson();
  }

  Future<void> save(ReviewRule reviewRule) async {
    var reviewsFile = await _localStorage.getFile(_resourceName);
    await reviewsFile.writeContents(_encode(reviewRule));
  }
}