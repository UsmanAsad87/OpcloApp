import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/commons/common_enum/notification_enum.dart';
import 'package:opclo/commons/common_functions/date_time_format.dart';
import 'package:opclo/features/user/notification/controller/notification_notifier_controller.dart';
import 'package:opclo/features/user/notification/helper/notification_helper.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/loading.dart';
import '../../../../commons/common_enum/reminder_option/repeat_option.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/notification_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../controller/notification_controller.dart';
import '../widgets/no_notifications.dart';
import '../widgets/notification_container.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  DateTime calculateNextOccurrence(NotificationModel notification) {
    DateTime now = DateTime.now();
    DateTime notificationTime = notification.createdAt;

    switch (notification.repeatOption) {
      case RepeatOption.None:
        return notificationTime;
      case RepeatOption.Daily:
        return now.isAfter(notificationTime)
            ? notificationTime.add(Duration(days: 1))
            : notificationTime;
      case RepeatOption.Weekly:
        int daysToAdd = (now.weekday <= notificationTime.weekday)
            ? notificationTime.weekday - now.weekday
            : 7 - (now.weekday - notificationTime.weekday);
        return now.add(Duration(days: daysToAdd));
      case RepeatOption.Monthly:
        return DateTime(now.year, now.month, notificationTime.day,
            notificationTime.hour, notificationTime.minute);
      case RepeatOption.Yearly:
        return DateTime(now.year, notificationTime.month, notificationTime.day,
            notificationTime.hour, notificationTime.minute);
      default:
        return notificationTime;
    }
  }

  List<NotificationModel> sortNotifications(
      List<NotificationModel> notifications) {
    notifications.sort((a, b) {
      DateTime nextOccurrenceA = calculateNextOccurrence(a);
      DateTime nextOccurrenceB = calculateNextOccurrence(b);
      return nextOccurrenceB.compareTo(nextOccurrenceA);
    });
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Consumer(builder: (context, ref, child) {
            return ref.watch(fetchAllNotificationProvider).when(
                data: (notifications) {
                  List<NotificationModel> sortedNotifications =
                      sortNotifications(notifications);
                  if (!sortedNotifications.isEmpty) {
                    return Expanded(
                      child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: sortedNotifications.length,
                          itemBuilder: (context, index) {
                            NotificationModel notification =
                                sortedNotifications[index];
                            if (notification.notificationType ==
                                NotificationEnum.alert) {
                              ref
                                  .read(notificationNotifierCtr.notifier)
                                  .increment();

                              return Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  await ref
                                      .read(notificationController.notifier)
                                      .deleteNotification(model: notification);
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                                child: NotificationContainer(
                                  notificationModel: notification,
                                  icon: getAlertIcon(
                                      notification.alertType?.type ?? ''),
                                  title: notification.notificationType ==
                                          NotificationEnum.admin
                                      ? notification.title
                                      : getTitle(notification.alertType!),
                                  // placeId: notification.placeId,
                                  subtitle: notification.description,
                                  time: formatTimeDifference(
                                    notification.createdAt,
                                  ),
                                  // notificationType: notification.notificationType,
                                  isMute: true,
                                ),
                              );
                            } else if (notification.notificationType ==
                                NotificationEnum.admin) {
                              ref
                                  .read(notificationNotifierCtr.notifier)
                                  .increment();
                              return Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  await ref
                                      .read(notificationController.notifier)
                                      .deleteNotification(model: notification);
                                },
                                background: Container(
                                  color: Colors.red,
                                  // Customize the background color when swiped
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                                child: NotificationContainer(
                                  notificationModel: notification,
                                  icon: AppAssets.notificationIcon,
                                  title: notification.notificationType ==
                                          NotificationEnum.admin
                                      ? notification.title
                                      : getTitle(notification.alertType!),
                                  // placeId: notification.placeId,
                                  subtitle: notification.description,
                                  time: formatTimeDifference(
                                      notification.createdAt),
                                  // notificationType: notification.notificationType,
                                  isMute: false,
                                ),
                              );
                            } else {
                              if (shouldDisplayNotification(notification)) {
                                ref
                                    .read(notificationNotifierCtr.notifier)
                                    .increment();
                                return Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.startToEnd,
                                    onDismissed: (direction) async {
                                      await ref
                                          .read(notificationController.notifier)
                                          .deleteNotification(
                                              model: notification);
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                    ),
                                    child: NotificationContainer(
                                      notificationModel: notification,
                                      icon: AppAssets.notificationIcon,
                                      title: notification.title,
                                      subtitle: notification.description,
                                      time: formatTimeDifference(
                                          NotificationHelper.getTime(
                                              notification)),
                                      // notificationType: notification.notificationType,
                                      isMute: true,
                                    ));
                              } else {
                                return Container();
                              }
                            }
                          }),
                    );
                  } else {
                    return NoNotifications();
                    // return Container();
                  }
                },
                error: (error, stackTrace) => SizedBox(),
                loading: () => LoadingWidget());
          }),
        ],
      ),
    );
  }

  bool shouldDisplayNotification(NotificationModel notification) {
    DateTime now = DateTime.now();
    DateTime notificationTime = notification.createdAt;
    RepeatOption repeatOption = notification.repeatOption!;
    switch (repeatOption) {
      case RepeatOption.None:
        return now.isAfter(notificationTime);

      case RepeatOption.Daily:
        return now.hour > notificationTime.hour ||
            (now.hour == notificationTime.hour &&
                now.minute > notificationTime.minute);

      case RepeatOption.Weekends:
        int today = now.weekday;
        bool isWeekend = today == DateTime.saturday || today == DateTime.sunday;
        return isWeekend &&
            NotificationHelper.shouldDisplayNotificationDaily(notification);

      case RepeatOption.Weekly:
        return now.weekday == notificationTime.weekday &&
            NotificationHelper.shouldDisplayNotificationDaily(notification);

      case RepeatOption.Monthly:
        return now.day == notificationTime.day &&
            NotificationHelper.shouldDisplayNotificationDaily(notification);

      case RepeatOption.Yearly:
        return now.month == notificationTime.month &&
            now.day == notificationTime.day &&
            NotificationHelper.shouldDisplayNotificationDaily(notification);

      default:
        return now.isAfter(notificationTime);
    }
  }

  String getAlertIcon(String title) {
    switch (title) {
      case 'incorrectHour':
        return AppAssets.hoursImage;
      case 'dineThurClosed':
        return AppAssets.driveImage;
      case 'dineInClosed':
        return AppAssets.driveImage;
      case 'womenOwned':
        return AppAssets.womenImage;
      case 'blackOwned':
        return AppAssets.blackOwnedImage;
      case 'maintenance':
        return AppAssets.maintenanceImage;
      case 'construction':
        return AppAssets.constructionImage;
      case 'movedLocation':
        return AppAssets.redLocationImage;
      case 'newAlert':
        return AppAssets.newAlertImage;
      case 'existingAlert':
        return AppAssets.alertImage;
      default:
        return AppAssets.hoursImage;
    }
  }

  String getTitle(AlertTypeEnum title) {
    switch (title) {
      case AlertTypeEnum.incorrectHour:
        return 'InCorrect Hours';
      case AlertTypeEnum.driveThruClosed:
        return 'dineThurClosed';
      case AlertTypeEnum.dineInClosed:
        return 'dineInClosed';
      case AlertTypeEnum.womenOwned:
        return 'WomenOwned';
      case AlertTypeEnum.blackOwned:
        return 'BlackOwned';
      case AlertTypeEnum.maintenance:
        return 'Maintenance';
      case AlertTypeEnum.construction:
        return 'Construction';
      case AlertTypeEnum.movedLocation:
        return 'MovedLocation';
      case AlertTypeEnum.newAlert:
        return 'NewAlert';
      case AlertTypeEnum.existingAlert:
        return 'ExistingAlert';
      default:
        return 'Default';
    }
  }
}
