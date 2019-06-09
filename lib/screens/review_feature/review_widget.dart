import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:travelconverter/internet_connectivity.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/state_container.dart';
import 'package:app_review/app_review.dart';

class ReviewWidget extends StatefulWidget {
  final Widget child;
  final LocalStorage localStorage;

  ReviewWidget({@required this.child, @required this.localStorage});

  @override
  State<StatefulWidget> createState() {
    return new ReviewWidgetState();
  }
}

class ReviewWidgetState extends State<ReviewWidget> {

  StreamSubscription<ConversionModel> _eventSubscription;

  ReviewStorage _reviewStorage;

  ReviewRule _reviewRule;

  @override
  void initState() {
    _reviewStorage = new ReviewStorage(widget.localStorage);
    _reviewStorage.read().then((review) {
      _reviewRule = review;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_eventSubscription != null) {
      _eventSubscription.cancel();
    }
    _eventSubscription = StateContainer.of(context).conversionUpdated.listen(_conversionUpdated);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_eventSubscription != null) {
      _eventSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _conversionUpdated(ConversionModel conversion) {
    _reviewRule.conversionDone();
    if (_reviewRule.shouldReview) {
      _doReview();
    } else {
      _reviewStorage.save(_reviewRule);
    }
  }

  void _doReview() async {
    _reviewStorage.save(_reviewRule);
    AppReview.requestReview;
  }
}

class ReviewStorage {

  static final Logger _log = new Logger<ReviewStorage>();

  final LocalStorage _localStorage;

  ReviewStorage(this._localStorage);

  ReviewRule _parse(String json) {
    Map data = new JsonDecoder().convert(json);
    return new ReviewRule(
      internet: new InternetConnectivityImpl(new Connectivity()),
      conversionsRequired: data['conversionsRequired'],
      conversionsDone: data['conversionsDone'],
      submitted: data['submitted'],
    );
  }

  Future<ReviewRule> read() async {
    var reviewsFile = await _localStorage.getFile("reviews.json");
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
    var json = new Map<String, dynamic>();
    json['conversionsRequired'] = rule.conversionsRequired;
    json['conversionsDone'] = rule.conversionsDone;
    json['submitted'] = rule.submitted;
    return new JsonEncoder().convert(json);
  }

  Future<void> save(ReviewRule reviewRule) async {
    var reviewsFile = await _localStorage.getFile("reviews.json");
    await reviewsFile.writeContents(_encode(reviewRule));
  }
}

class ReviewRule {
  final InternetConnectivity _internet;

  int _conversionsDone;
  int _conversionsRequired;
  bool _submitted;

  ReviewRule({InternetConnectivity internet, int conversionsDone, int conversionsRequired, bool submitted}):
        this._internet = internet,
        this._conversionsDone = conversionsDone,
        this._conversionsRequired = conversionsRequired,
        this._submitted = submitted;

  int get conversionsDone => _conversionsDone;
  int get conversionsRequired => _conversionsRequired;
  bool get submitted => _submitted;
  
  bool get shouldReview => !_submitted && _internet.isAvailable && _conversionsDone >= _conversionsRequired;

  void conversionDone() {
    _conversionsDone++;
    print("conversions done = $_conversionsDone");
  }
}