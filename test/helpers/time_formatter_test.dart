import 'package:flutter_test/flutter_test.dart';
import 'package:travelconverter/helpers/time_formatter.dart';
import 'package:travelconverter/l10n/app_localizations.dart';

class MockAppLocalizations extends AppLocalizations {
  MockAppLocalizations() : super('en');

  @override
  String get time_justNow => 'just now';

  @override
  String time_minutesAgo(int minutes) => '${minutes}m ago';

  @override
  String time_hoursAgo(int hours) => '${hours}h ago';

  @override
  String time_daysAgo(int days) => '${days}d ago';

  @override
  dynamic noSuchMethod(Invocation invocation) => '';
}

void main() {
  final l10n = MockAppLocalizations();

  group('formatRelativeTime', () {
    test('returns "just now" for times less than 1 minute ago', () {
      final now = DateTime.now();
      final justNow = now.subtract(Duration(seconds: 30));

      expect(formatRelativeTime(justNow, l10n), 'just now');
    });

    test('returns "just now" for times exactly 59 seconds ago', () {
      final now = DateTime.now();
      final justNow = now.subtract(Duration(seconds: 59));

      expect(formatRelativeTime(justNow, l10n), 'just now');
    });

    test('returns minutes for times 1 minute ago', () {
      final now = DateTime.now();
      final oneMinuteAgo = now.subtract(Duration(minutes: 1));

      expect(formatRelativeTime(oneMinuteAgo, l10n), '1m ago');
    });

    test('returns minutes for times between 1 and 59 minutes ago', () {
      final now = DateTime.now();

      final fiveMinutesAgo = now.subtract(Duration(minutes: 5));
      expect(formatRelativeTime(fiveMinutesAgo, l10n), '5m ago');

      final thirtyMinutesAgo = now.subtract(Duration(minutes: 30));
      expect(formatRelativeTime(thirtyMinutesAgo, l10n), '30m ago');

      final fiftyNineMinutesAgo = now.subtract(Duration(minutes: 59));
      expect(formatRelativeTime(fiftyNineMinutesAgo, l10n), '59m ago');
    });

    test('returns hours for times 1 hour ago', () {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(Duration(hours: 1));

      expect(formatRelativeTime(oneHourAgo, l10n), '1h ago');
    });

    test('returns hours for times between 1 and 23 hours ago', () {
      final now = DateTime.now();

      final twoHoursAgo = now.subtract(Duration(hours: 2));
      expect(formatRelativeTime(twoHoursAgo, l10n), '2h ago');

      final twelveHoursAgo = now.subtract(Duration(hours: 12));
      expect(formatRelativeTime(twelveHoursAgo, l10n), '12h ago');

      final twentyThreeHoursAgo = now.subtract(Duration(hours: 23));
      expect(formatRelativeTime(twentyThreeHoursAgo, l10n), '23h ago');
    });

    test('returns days for times 24 hours or more ago', () {
      final now = DateTime.now();

      final oneDayAgo = now.subtract(Duration(days: 1));
      expect(formatRelativeTime(oneDayAgo, l10n), '1d ago');

      final threeDaysAgo = now.subtract(Duration(days: 3));
      expect(formatRelativeTime(threeDaysAgo, l10n), '3d ago');

      final sevenDaysAgo = now.subtract(Duration(days: 7));
      expect(formatRelativeTime(sevenDaysAgo, l10n), '7d ago');
    });

    test('handles edge case at exactly 1 minute boundary', () {
      final now = DateTime.now();
      final exactlyOneMinute = now.subtract(Duration(minutes: 1, seconds: 0));

      expect(formatRelativeTime(exactlyOneMinute, l10n), '1m ago');
    });

    test('handles edge case at exactly 1 hour boundary', () {
      final now = DateTime.now();
      final exactlyOneHour = now.subtract(Duration(hours: 1, minutes: 0));

      expect(formatRelativeTime(exactlyOneHour, l10n), '1h ago');
    });

    test('handles edge case at exactly 24 hours boundary', () {
      final now = DateTime.now();
      final exactlyOneDay = now.subtract(Duration(hours: 24));

      expect(formatRelativeTime(exactlyOneDay, l10n), '1d ago');
    });

    test('handles large time differences', () {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(Duration(days: 30));

      expect(formatRelativeTime(thirtyDaysAgo, l10n), '30d ago');
    });
  });
}
