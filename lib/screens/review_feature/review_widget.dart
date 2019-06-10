import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/screens/review_feature/review_rule.dart';
import 'package:travelconverter/screens/review_feature/review_storage.dart';
import 'package:travelconverter/services/local_storage.dart';
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

  Future<void> _reviewAccepted() async {
    _reviewRule.reviewAccepted();
    await _reviewStorage.save(_reviewRule);
  }

  void _doReview() async {
    _reviewRule.reviewRequested();
    _reviewStorage.save(_reviewRule);
    Future.delayed(Duration(seconds: 1))
    .then((_) {
      final snackBar = new SnackBar(
        content: Text("Is this app helping you? Could you spare a minute to do a review? It really helps."),
        action: SnackBarAction(label: "Sure!", onPressed: () async {
          await _reviewAccepted();
          AppReview.requestReview;
        }),
        duration: Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
      );

      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
