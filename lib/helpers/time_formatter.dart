import 'package:travelconverter/l10n/app_localizations.dart';

String formatRelativeTime(DateTime dateTime, AppLocalizations l10n) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return l10n.time_justNow;
  } else if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return l10n.time_minutesAgo(minutes);
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return l10n.time_hoursAgo(hours);
  } else {
    final days = difference.inDays;
    return l10n.time_daysAgo(days);
  }
}
