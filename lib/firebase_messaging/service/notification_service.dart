import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/commons/common_enum/notification_enum.dart';
import 'package:opclo/features/user/notification/controller/notification_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../commons/common_enum/reminder_option/repeat_option.dart';
import '../../commons/common_imports/apis_commons.dart';
import '../../commons/common_widgets/show_toast.dart';
import '../../main.dart';
import '../../models/notification_model.dart';
import '../../routes/route_manager.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  // static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings();

  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      '[Utils.requestPermission()] - Permission ${permission.toString()} was already granted';
      return true;
    } else {
      final result = await permission.request();
      if (result == PermissionStatus.granted) {
        '[Utils.requestPermission()] - Permission ${permission.toString()} granted!';
        return true;
      } else {
        '[Utils.requestPermission()] - Permission ${permission.toString()} denied!';
        return false;
      }
    }
  }

  static void initializeNew() {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification:
      //     (int id, String? title, String? body, String? payload) {
      //   if (payload != null && payload != '') {
      //     navigatorKey.currentState?.pushNamed(
      //         AppRoutes.placeDetailUsingIdScreen,
      //         arguments: {'placeId': payload});
      //   }
      // },
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null && details.payload != '') {
          navigatorKey.currentState?.pushNamed(
              AppRoutes.placeDetailUsingIdScreen,
              arguments: {'placeId': details.payload});
        }
      },
    );
  }

  static Future<void> initializeNew1() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification:
      //     (int id, String? title, String? body, String? payload) {
      //   if (payload != null && payload != '') {
      //     navigatorKey.currentState?.pushNamed(
      //         AppRoutes.placeDetailUsingIdScreen,
      //         arguments: {'placeId': payload});
      //   }
      // },
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null && details.payload != '') {
          navigatorKey.currentState?.pushNamed(
              AppRoutes.placeDetailUsingIdScreen,
              arguments: {'placeId': details.payload});
        }
      },
    );
  }

  static void display({
    required RemoteMessage message,
    required BuildContext context,
    required WidgetRef ref,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    // Map<String, dynamic> notificationData =
    //     parseNotificationString(message.data['screen']);
    Map<String, dynamic> notificationData = jsonDecode(message.data['screen']);

    NotificationModel model = NotificationModel(
      notificationId: Uuid().v4(),
      title: notificationData['title'],
      description: notificationData['description'],
      placeId: notificationData['placeId'],
      placeName: notificationData['placeName'],
      alertType: notificationData['alertType'] != null
          ? (notificationData['alertType'] as String).toAlertTypeEnum()
          : null,
      notificationType: notificationData['notificationType'] != null
          ? (notificationData['notificationType'] as String)
              .toNotificationTypeEnum()
          : NotificationEnum.admin,
      // NotificationEnum.alert,
      //(notificationData['notificationType'] as String).toNotificationTypeEnum(),
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(notificationData['createdAt']),
    );
    switch (model.notificationType) {
      case NotificationEnum.alert:
        navigatorKey.currentState?.pushNamed(AppRoutes.placeDetailUsingIdScreen,
            arguments: {'placeId': model.placeId});
        return showNotification(model: model, ref: ref);
      default:
        return showNotification(model: model, ref: ref);
    }
  }

  static void displayBackgroundNotifications({
    required RemoteMessage message,
    required BuildContext context,
    // required WidgetRef ref,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    Map<String, dynamic> notificationData =
        parseNotificationString(message.data['screen']);
    NotificationModel model = NotificationModel(
      notificationId: notificationData['notificationId'],
      title: notificationData['title'],
      description: notificationData['description'],
      notificationType: NotificationEnum.alert,
      //(notificationData['notificationType'] as String).toNotificationTypeEnum(),
      placeName: notificationData['placeName'],
      alertType: notificationData['alertType'] != null
          ? (notificationData['alertType'] as String).toAlertTypeEnum()
          : null,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(notificationData['createdAt']),
      placeId: notificationData['placeId'],
    );
    switch (model.notificationType) {
      case NotificationEnum.alert:
        navigatorKey.currentState?.pushNamed(AppRoutes.placeDetailUsingIdScreen,
            arguments: {'placeId': model.placeId});
        return;
      default:
        return;
    }
  }

  static showNotification({
    required NotificationModel model,
    required WidgetRef ref,
  }) async {
    try {
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            presentBanner: true,
            presentList: true,
            categoryIdentifier: 'plainCategory',
          ),
          android: AndroidNotificationDetails(
            'mychanel',
            'my chanel',
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ));
      await _flutterLocalNotificationsPlugin.show(
        id,
        model.title,
        model.description,
        notificationDetails,
      );

      ref.read(notificationController.notifier).addNotification(
            model: model,
          );
    } on Exception catch (e) {
      debugPrint('Error>>>$e');
    }
  }

  static Map<String, dynamic> parseNotificationString(
      String notificationString) {
    List<String> keyValuePairs = notificationString
        .replaceAll('{', '')
        .replaceAll('}', '')
        .split(', ')
        .where((element) => element.isNotEmpty)
        .toList();

    Map<String, dynamic> notificationData = {};
    for (String pair in keyValuePairs) {
      List<String> parts = pair.split(': ');
      if (parts.length == 2) {
        notificationData[parts[0].trim()] = parts[1].trim();
      }
    }
    return notificationData;
  }

  final platformNotificationDetails = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: 'plainCategory',
      ),
      android: AndroidNotificationDetails(
        "myChannel",
        "my chanel",
        importance: Importance.max,
        priority: Priority.high,
      ));

  Future<void> cancelNotification({required int id}) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    showToast(msg: 'Mute Successfully');
  }

  Future<void> scheduleNotificationDailyCheckList({
    required int id,
    required DateTime scheduledTime,
    required String title,
    required String desc,
    required RepeatOption option,
    required String payLoad,
  }) async {
    switch (option) {
      case RepeatOption.None:
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          desc,
          tz.TZDateTime.from(
            scheduledTime,
            tz.local,
          ),
          platformNotificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          // androidAllowWhileIdle: true,
          payload: payLoad,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
        );
        break;
      case RepeatOption.Daily:
        await _flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            desc,
            tz.TZDateTime.from(
              scheduledTime,
              tz.local,
            ),
            platformNotificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            // androidAllowWhileIdle: true,
            payload: payLoad,
            matchDateTimeComponents: DateTimeComponents.time,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
        );
        break;
      case RepeatOption.Weekends:
        var nextWeekend = scheduledTime.weekday == DateTime.saturday ||
                scheduledTime.weekday == DateTime.sunday
            ? scheduledTime
            : DateTime(
                scheduledTime.year,
                scheduledTime.month,
                scheduledTime.day +
                    (DateTime.saturday - scheduledTime.weekday));

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          desc,
          tz.TZDateTime.from(
            nextWeekend,
            tz.local,
          ),
          platformNotificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          // androidAllowWhileIdle: true,
          payload: payLoad,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
        );
        break;
      case RepeatOption.Weekly:
        await _flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            desc,
            tz.TZDateTime.from(
              scheduledTime,
              tz.local,
            ),
            platformNotificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            // androidAllowWhileIdle: true,
            payload: payLoad,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
        );
        break;
      case RepeatOption.Monthly:
        await _flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            desc,
            tz.TZDateTime.from(
              scheduledTime,
              tz.local,
            ),
            platformNotificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            // androidAllowWhileIdle: true,
            payload: payLoad,
            matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
        break;
      case RepeatOption.Yearly:
        await _flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            desc,
            tz.TZDateTime.from(
              scheduledTime,
              tz.local,
            ),
            platformNotificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            // androidAllowWhileIdle: true,
            payload: payLoad,
            matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
        break;
    }
  }

  showNoteNotification({required String title, required String body}) async {
    Random random = Random();
    int id = random.nextInt(1000);
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformNotificationDetails,
    );
  }

}
