import 'package:intl/intl.dart';

class AppFormatedTime {
  static String formatTime(String time) {
    DateTime localTime = DateTime.parse(time).toLocal();
    return DateFormat('hh:mm a - dd/MM/yyyy').format(localTime);
  }

  static String getDuration(String start, String end) {
    Duration duration = DateTime.parse(end).difference(DateTime.parse(start));
    return duration.toString().split('.').first.padLeft(8, "0");
  }

  static String getTime(String time) {
    return DateFormat.jm().format(DateTime.parse(time).toLocal());
  }

  static String smartTimestamp(String time) {
    final now = DateTime.now();
    final date = DateTime.parse(time).toLocal();

    final difference = now.difference(date);

    // Just now (within 1 minute)
    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    // Today
    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      return DateFormat.jm().format(date); // e.g., 4:05 PM
    }

    // Yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.day == date.day &&
        yesterday.month == date.month &&
        yesterday.year == date.year) {
      return 'Yesterday';
    }

    // This week (within last 7 days but not today or yesterday)
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    if (date.isAfter(oneWeekAgo)) {
      return DateFormat('EEEE').format(date); // e.g., Wednesday
    }

    // Older (show full date)
    return DateFormat('MMM d, yyyy').format(date); // e.g., Aug 1, 2025
  }
}
