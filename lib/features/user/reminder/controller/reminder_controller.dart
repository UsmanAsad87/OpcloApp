import 'dart:math';
import 'package:opclo/commons/common_enum/notification_enum.dart';
import 'package:opclo/features/user/reminder/api/dynamic_link_service.dart';
import 'package:opclo/features/user/reminder/api/reminder_api.dart';
import 'package:uuid/uuid.dart';
import '../../../../commons/common_enum/reminder_option/repeat_option.dart';
import '../../../../commons/common_functions/date_time_format.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../firebase_messaging/service/notification_service.dart';
import '../../../../models/notification_model.dart';
import '../../../../models/reminder_model.dart';
import '../../../auth/data/auth_apis/auth_apis.dart';
import '../../notification/api/notification_api.dart';
import 'notification_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_calendar/device_calendar.dart';

final reminderControllerProvider =
    StateNotifierProvider<ReminderController, bool>((ref) {
  final notificationDatabaseApi = ref.watch(notificationApisProvider);
  return ReminderController(
    authApis: ref.watch(authApisProvider),
    notificationDatabaseApi: notificationDatabaseApi,
    databaseApis: ref.watch(reminderDatabaseApiProvider),
  );
});

final getAllRemindersProvider = StreamProvider((
  ref,
) {
  final couponCtr = ref.watch(reminderControllerProvider.notifier);
  return couponCtr.getAllReminders();
});

class ReminderController extends StateNotifier<bool> {
  final ReminderDatabaseApi _databaseApis;
  final NotificationDatabaseApi _notificationDatabaseApi;
  final AuthApis _authApis;

  ReminderController({
    required ReminderDatabaseApi databaseApis,
    required NotificationDatabaseApi notificationDatabaseApi,
    required AuthApis authApis,
  })  : _databaseApis = databaseApis,
        _notificationDatabaseApi = notificationDatabaseApi,
        _authApis = authApis,
        super(false);


  /// Test code for calender
  /*
  if (reminderModel.addToCalendar) {
  final DeviceCalendarPlugin _deviceCalendarPlugin =
  DeviceCalendarPlugin();
  final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
  //print(calendarsResult.data!.first.name.toString());
  Calendar _deviceCalendar = calendarsResult.data!.first;

  calendarsResult.data!.forEach((el) {
  if(el.accountType!= null){
  if(el.accountName == "usmanasad0324@gmail.com" && el.name=="9th A to j" ){
  _deviceCalendar = el;
  print(el.name);
  }
  }
  });
  // print(_deviceCalendar.accountName);
  // print(_deviceCalendar.name);

  _addReminder(
  id: _deviceCalendar.id!,
  reminder: reminderModel,
  deviceCalendarPlugin: _deviceCalendarPlugin);
  }
  state = false;

  return;
  */






  Future<void> addReminder({
    required BuildContext context,
    required ReminderModel reminderModel,
    required bool isInvite,
  }) async {
    state = true;

    final result =
        await _databaseApis.addReminder(reminderModel: reminderModel);
    if (isInvite) {
      await DynamicLinkService.buildDynamicLinkForReminder(
              true, reminderModel.id)
          .then((value) => Share.share(value));
    }
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      LocalNotificationService().scheduleNotificationDailyCheckList(
          id: int.parse(reminderModel.cancellationId),
          title: 'Opclo Reminder',
          desc:
              'Your Opclo reminder for ${reminderModel.placeName} is ready. Let\'s go!',
          scheduledTime: reminderModel.reminderDate,
          option: _getRepeatOption(reminderModel.repeatOption,
          ),
        payLoad: reminderModel.fsqId
      );
      try{
        if (reminderModel.addToCalendar) {
          final DeviceCalendarPlugin _deviceCalendarPlugin =
          DeviceCalendarPlugin();
          final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
          Calendar _deviceCalendar = calendarsResult.data!.first;
          _addReminder(
              id: _deviceCalendar.id!,
              reminder: reminderModel,
              deviceCalendarPlugin: _deviceCalendarPlugin);
        }
      }catch(e){
        debugPrint("Error while adding reminder to calender");
      }


      /// create Notification Model
      NotificationModel notificationModel = NotificationModel(
          title: 'Reminder',
          notificationId: Uuid().v4(),
          description: 'Its time to go to  ${reminderModel.placeName}',
          createdAt: reminderModel.reminderDate,
          placeId: reminderModel.fsqId,
          placeName: reminderModel.placeName,
          reminderId: int.parse(reminderModel.cancellationId),
          notificationType: NotificationEnum.reminder,
          repeatOption: reminderModel.repeatOption);
      addNotification(model: notificationModel);
      showSnackBar(context, 'Reminder added successfully');
      if (reminderModel.addToCalendar) {
        final DeviceCalendarPlugin _deviceCalendarPlugin =
        DeviceCalendarPlugin();
        final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
        Calendar _deviceCalendar = calendarsResult.data!.first;
        _addReminder(
            id: _deviceCalendar.id!,
            reminder: reminderModel,
            deviceCalendarPlugin: _deviceCalendarPlugin);
      }
      Navigator.of(context).pop();
    });
  }

  Future<void> _addReminder(
      {required String id,
      required ReminderModel reminder,
      required DeviceCalendarPlugin deviceCalendarPlugin}) async {
    String timeZoneName = 'UTC';
    Location timeZone = getLocation(timeZoneName);

    final event = Event(
        id,
        // eventId: reminder.id,
        title: reminder.placeName,
        start: TZDateTime.from(reminder.reminderDate, timeZone),
        end: TZDateTime.from(reminder.reminderDate, timeZone),
        recurrenceRule: reminder.repeatOption == RepeatOption.Weekends
            ? RecurrenceRule(
                RecurrenceFrequency.Weekly,
                daysOfWeek: [DayOfWeek.Saturday, DayOfWeek.Sunday],
              )
            : RecurrenceRule(
                _getRecurrence(reminder.repeatOption),
              ));

    final result = await deviceCalendarPlugin.createOrUpdateEvent(event);
    if (result!.isSuccess && result.data != null) {
      debugPrint('Reminder added successfully');
    } else {
      debugPrint('Failed to add reminder');
    }
  }

  RecurrenceFrequency? _getRecurrence(RepeatOption repeatOption) {
    switch (repeatOption) {
      case RepeatOption.None:
        return RecurrenceFrequency.values[0];
      case RepeatOption.Daily:
        return RecurrenceFrequency.Daily;
      case RepeatOption.Weekends:
        return RecurrenceFrequency.Weekly;
      case RepeatOption.Weekly:
        return RecurrenceFrequency.Weekly;
      case RepeatOption.Monthly:
        return RecurrenceFrequency.Monthly;
      case RepeatOption.Yearly:
        return RecurrenceFrequency.Yearly;
      default:
        return null;
    }
  }

  RepeatOption _getRepeatOption(RepeatOption repeatOption) {
    switch (repeatOption) {
      case RepeatOption.None:
        return RepeatOption.None;
      case RepeatOption.Daily:
        return RepeatOption.Daily;
      case RepeatOption.Weekends:
        return RepeatOption.Weekends;
      case RepeatOption.Weekly:
        return RepeatOption.Weekly;
      case RepeatOption.Monthly:
        return RepeatOption.Monthly;
      case RepeatOption.Yearly:
        return RepeatOption.Yearly;
      default:
        return RepeatOption.None;
    }
  }

  Stream<List<ReminderModel>> getAllReminders() {
    try {
      Stream<List<ReminderModel>> reminders = _databaseApis.getAllReminders();
      return reminders;
    } catch (error) {
      return const Stream.empty();
      // Handle the error as needed
    }
  }

  Stream<ReminderModel> getReminderById({required String reminderId}) {
    try {
      Stream<ReminderModel> reminder =
          _databaseApis.getReminderById(reminderId: reminderId);
      return reminder;
    } catch (error) {
      return const Stream.empty();
      // Handle the error as needed
    }
  }

  void addNotification({
    required NotificationModel model,
  }) {
    final userId = _authApis.getCurrUser()?.uid;
    _notificationDatabaseApi.addNotification(
        notification: model, userId: userId ?? '');
  }
}
