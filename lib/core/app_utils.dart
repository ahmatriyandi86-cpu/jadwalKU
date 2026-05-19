class AppUtils {
  static String formatRelativeDeadline(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(deadline.year, deadline.month, deadline.day);
    final difference = targetDate.difference(today).inDays;

    final monthsText = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final dateString = '${deadline.day} ${monthsText[deadline.month - 1]}';

    if (difference == 0) {
      return '$dateString (Hari Ini)';
    } else if (difference == 1) {
      return '$dateString (Besok)';
    } else if (difference == -1) {
      return '$dateString (Kemarin)';
    } else if (difference > 1) {
      return '$dateString ($difference hari lagi)';
    } else {
      return '$dateString (${difference.abs()} hari lalu)';
    }
  }
}
