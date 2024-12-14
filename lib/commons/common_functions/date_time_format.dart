import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

String formatDateAndMonth(DateTime dateTime) {
  return DateFormat.yMMM().format(dateTime);
}

String formatDateAndMonthandYear(DateTime dateTime) {
  return DateFormat.yMMM().format(dateTime);
}

String formatDayMonthYear(DateTime dateTime) {
  return DateFormat('MMM dd, yyyy').format(dateTime);
}

String formatFullTime(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);
}

String notesDate(DateTime dateTime) {
  return DateFormat('MMM dd yyyy,').format(dateTime);
}

String notesTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

String formatCalenderDate(DateTime dateTime) {
  return DateFormat('EEEE MMMM, dd').format(dateTime);
}

String formatCalenderTime(DateTime dateTime) {
  return DateFormat('hh a').format(dateTime);
}

String formatTimeDifference(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime).abs();

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}s';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else if (difference.inDays == 1) {
    return 'yesterday';
  } else if (difference.inDays < 30) {
    return '${difference.inDays}d';
  } else if (difference.inDays < 365) {
    final months = difference.inDays ~/ 30;
    return months.toString() + 'm';
  } else {
    final years = difference.inDays ~/ 365;
    return years.toString() + 'y';
  }
}

String formatTimeDifference2(DateTime dateTime) {
  final now = DateTime.now();
  final difference = dateTime.difference(now).abs();

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} s';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} h';
  } else if (difference.inDays == 1) {
    return 'yesterday';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} d';
  } else if (difference.inDays < 365) {
    final months = difference.inDays ~/ 30;
    return '$months m';
  } else {
    final years = difference.inDays ~/ 365;
    return '$years y';
  }
}