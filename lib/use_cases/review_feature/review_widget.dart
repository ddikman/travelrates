import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/widgets/app_snack_bar.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/use_cases/review_feature/app_review_service.dart';
import 'package:travelconverter/use_cases/review_feature/review_rule.dart';
import 'package:travelconverter/use_cases/review_feature/review_storage.dart';
import 'package:travelconverter/state_container.dart';

class ReviewWidget extends StatefulWidget {
  final Widget child;
  final ReviewStorage reviewStorage;
  final Duration toastDelay;

  ReviewWidget(
      {required this.child,
      required this.reviewStorage,
      this.toastDelay = const Duration(seconds: 1)});

  @override
  State<StatefulWidget> createState() {
    return new ReviewWidgetState();
  }
}

class ReviewWidgetState extends State<ReviewWidget> {
  StreamSubscription<ConversionModel>? _eventSubscription;

  late ReviewRule _reviewRule;

  @override
  void initState() {
    widget.reviewStorage.read().then((review) {
      _reviewRule = review;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _eventSubscription?.cancel();
    _eventSubscription =
        StateContainer.of(context).conversionUpdated.listen(_conversionUpdated);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
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

    final action = SnackBarAction(
        label: acceptReviewButtonText,
        onPressed: () async {
          await _reviewAccepted();
          await AppReviewService().request();
        });

    await Future.delayed(widget.toastDelay).then((_) {
      AppSnackBar.show(context,
          accentColor: lightTheme.accent,
          duration: Duration(seconds: 10),
          text: toastMessage,
          action: action);
    });
  }

  static String get toastMessage => Intl.message(
      "Is TravelRates working well for you?\nIf you can leave a review, it really helps.",
      name: "ReviewWidgetState_toastMessage",
      desc: "Message shown in review request toast");

  static String get acceptReviewButtonText => Intl.message("Sure!",
      name: "ReviewWidgetState_acceptReviewButtonText",
      desc: "Short text to accept to a review");
}
