import 'package:travelconverter/internet_connectivity.dart';
import 'package:travelconverter/services/logger.dart';

class ReviewRule {
  static Logger<ReviewRule> _log = new Logger<ReviewRule>();

  final InternetConnectivity _internet;

  int _conversionsDone;
  int _conversionsRequired;
  bool _submitted = false;

  ReviewRule(
      {required InternetConnectivity internet,
      int conversionsDone = 0,
      int conversionsRequired = 0,
      bool submitted = false})
      : this._internet = internet,
        this._conversionsDone = conversionsDone,
        this._conversionsRequired = conversionsRequired,
        this._submitted = submitted;

  int get conversionsDone => _conversionsDone;
  int get conversionsRequired => _conversionsRequired;
  bool get submitted => _submitted;

  bool get shouldReview =>
      !submitted &&
      _internet.isAvailable &&
      _conversionsDone >= _conversionsRequired;

  void conversionDone() {
    if (_submitted) return;
    _conversionsDone++;
    _log.debug(
        "review will be done after $_conversionsRequired, conversions done now $_conversionsDone");
  }

  void reviewRequested() {
    _conversionsRequired = _conversionsRequired * 2;
    _log.debug(
        "review requested, next review will be requested after $_conversionsRequired conversions");
  }

  void reviewAccepted() {
    this._submitted = true;
    _log.event("review", "review request was accepted",
        parameters: {'state': 'requested'});
  }
}
