import '../../../../commons/common_enum/reminder_option/repeat_option.dart';
import '../../../../commons/common_functions/date_time_format.dart';
import '../../../../models/notification_model.dart';

class NotificationHelper{

  static DateTime getTime(NotificationModel notification) {
    DateTime now = DateTime.now();
    DateTime notificationTime = notification.createdAt;
    RepeatOption repeatOption = notification.repeatOption!;
    switch (repeatOption) {
      case RepeatOption.None:
        return notificationTime;

      case RepeatOption.Daily:
        if (now.hour > notificationTime.hour ||
            (now.hour == notificationTime.hour &&
                now.minute > notificationTime.minute)) {
          return notificationTime;
        } else {
          return notificationTime;
        }

      case RepeatOption.Weekends:
        int today = now.weekday;
        bool isWeekend = today == DateTime.saturday || today == DateTime.sunday;
        if (isWeekend && shouldDisplayNotificationDaily(notification)) {
          return notificationTime.add(Duration(days: 7));
        } else {
          return notificationTime;
        }

      case RepeatOption.Weekly:
        if (now.weekday == notificationTime.weekday &&
            shouldDisplayNotificationDaily(notification)) {
          return notificationTime.add(Duration(days: 7));
        } else {
          return notificationTime;
        }

      case RepeatOption.Monthly:
        if (now.day == notificationTime.day &&
            shouldDisplayNotificationDaily(notification)) {
          return NotificationHelper.addOneMonth(notificationTime);
        } else {
          return notificationTime;
        }

      case RepeatOption.Yearly:
        if (now.month == notificationTime.month &&
            now.day == notificationTime.day &&
            shouldDisplayNotificationDaily(notification)) {
          return NotificationHelper.addOneYear(notificationTime);
        } else {
          return notificationTime;
        }

      default:
        return notificationTime;
    }
  }

  static bool shouldDisplayNotificationDaily(NotificationModel notification) {
    DateTime now = DateTime.now();
    DateTime notificationTime = notification.createdAt;
    // Check if the current time (ignoring date and month) is after the notification time
    return now.hour > notificationTime.hour ||
        (now.hour == notificationTime.hour &&
            now.minute > notificationTime.minute);
  }

  static DateTime addOneYear(DateTime dateTime) {
    DateTime newDateTime = DateTime(
      dateTime.year + 1,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );

    return newDateTime;
  }

  static DateTime addOneMonth(DateTime dateTime) {
    DateTime newDateTime = DateTime(
        dateTime.year,
        dateTime.month + 1,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond,
        dateTime.microsecond);
    if (newDateTime.month > 12) {
      newDateTime = DateTime(
          dateTime.year + 1,
          1,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond);
    }
    return newDateTime;
  }

}