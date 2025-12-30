String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 3) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return '${minutes}m ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '${hours}h ago';
  } else {
    final days = difference.inDays;
    return '${days}d ago';
  }
}
