
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/screens/convert/reviews.dart';

import 'mocks/mock_internet_connectivity.dart';

void main() {
  bool reviewRequested = false;
  MockInternetConnectivity internet = new MockInternetConnectivity();

  hasConversions({int done, int required}) {
    internet.setAvailable(true);
    reviewRequested = false;
    return new ReviewsImpl(
      onReviewRequested: () => reviewRequested = true,
      internetConnectivity: internet,
      conversionsDone: done,
      conversionsRequired: required
    );
  }

  test('increases conversions after each conversions done call', () {
    final reviews = hasConversions(done: 0, required: 5);
    reviews.conversionDone();
    expect(reviews.conversionsDone, 1);
    reviews.conversionDone();
    expect(reviews.conversionsDone, 2);
  });

  test('requests review when enough conversions have been done', () async {
    var reviews = hasConversions(done: 4, required: 5);
    reviews.conversionDone();
    expect(reviewRequested, true);
  });

  test('each time review is declined, required reviews double', () async {
    var reviews = hasConversions(done: 4, required: 5);
    reviews.conversionDone();
    reviews.reviewDeclined();
    expect(reviews.conversionsRequired, 10);
  });

  test('review is requested only if there is internet', () {
    // when only one conversion remains before we prompt
    final reviews = hasConversions(done: 4, required: 5);
    internet.setAvailable(false);

    // and we do that conversion
    reviews.conversionDone();

    // then, because we lack internet, review isn't requested
    expect(reviewRequested, false);

    // then if internet becomes available and we do another conversion
    internet.setAvailable(true);
    reviews.conversionDone();

    // review is requested
    expect(reviewRequested, true);
  });
}