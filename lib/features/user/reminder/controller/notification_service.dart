// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:opclo/commons/common_enum/reminder_option/repeat_option.dart';
// import 'package:opclo/commons/common_widgets/show_toast.dart';
// import 'package:timezone/timezone.dart' as tz;
// import '../../../../main.dart';
// import '../../../../routes/route_manager.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin
//       _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   final DarwinInitializationSettings initializationSettingsDarwin =
//       const DarwinInitializationSettings();
//
//   static void initialize() {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//
//     var initializationSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification:
//             (int id, String? title, String? body, String? payload) {
//           navigatorKey.currentState?.pushNamed(
//               AppRoutes.placeDetailUsingIdScreen,
//               arguments: {'placeId': payload});
//         },);
//
//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {
//         if (details.payload != null) {
//           navigatorKey.currentState?.pushNamed(
//               AppRoutes.placeDetailUsingIdScreen,
//               arguments: {'placeId': details.payload});
//         }
//       },
//       // onDidReceiveBackgroundNotificationResponse: (details) {
//       //   if (details.payload != null) {
//       //     navigatorKey.currentState?.pushNamed(
//       //         AppRoutes.placeDetailUsingIdScreen,
//       //         arguments: {'placeId': details.payload});
//       //   }
//       // },
//     );
//   }
//
//   final platformNotificationDetails = const NotificationDetails(
//       iOS: DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         categoryIdentifier: 'plainCategory',
//       ),
//       android: AndroidNotificationDetails(
//         "myChannel",
//         "my chanel",
//         importance: Importance.max,
//         priority: Priority.high,
//       ));
//
//   Future<void> cancelNotification({required int id}) async {
//     print(id);
//     await _flutterLocalNotificationsPlugin.cancel(id);
//     showToast(msg: 'Mute Successfully');
//   }
//
//   Future<void> scheduleNotificationDailyCheckList({
//     required int id,
//     required DateTime scheduledTime,
//     required String title,
//     required String desc,
//     required RepeatOption option,
//     required String payLoad,
//   }) async {
//
//     switch (option) {
//       case RepeatOption.None:
//         await _flutterLocalNotificationsPlugin.zonedSchedule(
//           id,
//           title,
//           desc,
//           tz.TZDateTime.from(
//             scheduledTime,
//             tz.local,
//           ),
//           platformNotificationDetails,
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//           androidAllowWhileIdle: true,
//           payload: payLoad,
//         );
//         break;
//       case RepeatOption.Daily:
//         await _flutterLocalNotificationsPlugin.zonedSchedule(
//             id,
//             title,
//             desc,
//             tz.TZDateTime.from(
//               scheduledTime,
//               tz.local,
//             ),
//             platformNotificationDetails,
//             uiLocalNotificationDateInterpretation:
//                 UILocalNotificationDateInterpretation.absoluteTime,
//             androidAllowWhileIdle: true,
//             payload: payLoad,
//             matchDateTimeComponents: DateTimeComponents.time);
//         break;
//       case RepeatOption.Weekends:
//         // Schedule for weekends
//         // First, find the next Saturday or Sunday
//         var nextWeekend = scheduledTime.weekday == DateTime.saturday ||
//                 scheduledTime.weekday == DateTime.sunday
//             ? scheduledTime
//             : DateTime(
//                 scheduledTime.year,
//                 scheduledTime.month,
//                 scheduledTime.day +
//                     (DateTime.saturday - scheduledTime.weekday));
//
//         await _flutterLocalNotificationsPlugin.zonedSchedule(
//           id,
//           title,
//           desc,
//           tz.TZDateTime.from(
//             nextWeekend,
//             tz.local,
//           ),
//           platformNotificationDetails,
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//           androidAllowWhileIdle: true,
//           payload: payLoad,
//           matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//         );
//         break;
//       case RepeatOption.Weekly:
//         await _flutterLocalNotificationsPlugin.zonedSchedule(
//             id,
//             title,
//             desc,
//             tz.TZDateTime.from(
//               scheduledTime,
//               tz.local,
//             ),
//             platformNotificationDetails,
//             uiLocalNotificationDateInterpretation:
//                 UILocalNotificationDateInterpretation.absoluteTime,
//             androidAllowWhileIdle: true,
//             payload: payLoad,
//             matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
//         break;
//       case RepeatOption.Monthly:
//         await _flutterLocalNotificationsPlugin.zonedSchedule(
//             id,
//             title,
//             desc,
//             tz.TZDateTime.from(
//               scheduledTime,
//               tz.local,
//             ),
//             platformNotificationDetails,
//             uiLocalNotificationDateInterpretation:
//                 UILocalNotificationDateInterpretation.absoluteTime,
//             androidAllowWhileIdle: true,
//             payload: payLoad,
//             matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
//         break;
//       case RepeatOption.Yearly:
//         await _flutterLocalNotificationsPlugin.zonedSchedule(
//             id,
//             title,
//             desc,
//             tz.TZDateTime.from(
//               scheduledTime,
//               tz.local,
//             ),
//             platformNotificationDetails,
//             uiLocalNotificationDateInterpretation:
//                 UILocalNotificationDateInterpretation.absoluteTime,
//             androidAllowWhileIdle: true,
//             payload: payLoad,
//             matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
//         break;
//     }
//   }
// }
