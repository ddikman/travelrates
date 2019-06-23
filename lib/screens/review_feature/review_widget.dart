import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/screens/review_feature/review_rule.dart';
import 'package:travelconverter/screens/review_feature/review_storage.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/state_container.dart';
import 'package:app_review/app_review.dart';

class ReviewWidget extends StatefulWidget {
  final Widget child;
  final ReviewStorage reviewStorage;
  final Duration toastDelay;

  ReviewWidget({@required this.child, @required this.reviewStorage, this.toastDelay});

  @override
  State<StatefulWidget> createState() {
    return new ReviewWidgetState();
  }
}

class ReviewWidgetState extends State<ReviewWidget> {

  static final _logger = new Logger<ReviewWidgetState>();

  StreamSubscription<ConversionModel> _eventSubscription;

  ReviewRule _reviewRule;

  @override
  void initState() {
    widget.reviewStorage.read().then((review) {
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
    } else if (!_reviewRule.submitted) {
      this.widget.reviewStorage.save(_reviewRule);
    }
  }

  Future<void> _reviewAccepted() async {
    _reviewRule.reviewAccepted();
    await this.widget.reviewStorage.save(_reviewRule);
  }

  void _doReview() async {
    _reviewRule.reviewRequested();
    this.widget.reviewStorage.save(_reviewRule);
    Future.delayed(widget.toastDelay ?? Duration(seconds: 1))
    .then((_) {
      final snackBar = new SnackBar(
        content: Text(toastMessage),
        action: SnackBarAction(label: acceptReviewButtonText, onPressed: () async {
          await _reviewAccepted();
          if (await _canPromptReview()) {
            final result = await AppReview.requestReview;
            _logger.debug(result);
          } else {
            final result = await AppReview.storeListing;
            _logger.debug(result);
          }
        }),
        duration: Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
      );

      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  /// Actually need to check if the platform supports the reviews.
  /// This isn't handled properly in the app_review package.
  Future<bool> _canPromptReview() async {
    if (!Platform.isIOS) {
      return true;
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    final iosVersion = iosInfo.systemVersion;
    _logger.debug("Running on ios version $iosVersion");

    final versionParts = iosVersion.split('.');
    final major = int.parse(versionParts[0]);
    final minor = int.parse(versionParts[1]);
    return major > 10 || (major == 10 && minor > 3);
  }

  static String get toastMessage => Intl.message(
      "Is this app helping you? Could you spare a minute to do a review? It really helps.",
      name: "ReviewWidgetState_toastMessage",
      desc: "Message shown in review request toast"
  );

  static String get acceptReviewButtonText => Intl.message(
      "Sure!",
      name: "ReviewWidgetState_acceptReviewButtonText",
      desc: "Short text to accept to a review"
  );
}
