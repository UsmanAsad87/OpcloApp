enum NotificationEnum {
  reminder('reminder'),
  admin('admin'),
  alert('alert');

  const NotificationEnum(this.type);

  final String type;
}

// enhanced enums
extension ConvertNotificationTypeEnum on String {
  NotificationEnum toNotificationTypeEnum() {
    switch (this) {
      case 'reminder':
        return NotificationEnum.reminder;
      case 'alert':
        return NotificationEnum.alert;
      case 'admin':
        return NotificationEnum.admin;
      default:
        return NotificationEnum.reminder;
    }
  }
}
