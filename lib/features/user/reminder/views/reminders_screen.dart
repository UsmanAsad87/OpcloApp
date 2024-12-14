import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/reminder/controller/reminder_controller.dart';
import 'package:opclo/features/user/reminder/widgets/reminder_button.dart';
import 'package:opclo/features/user/reminder/widgets/reminder_container.dart';
import 'package:opclo/models/reminder_model.dart';
import 'package:opclo/routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/thems/styles_manager.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool isPast = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: Padding(
        padding: EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [
            SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: context.titleColor,
                          size: 18.r,
                        ),
                      ),
                      Text(
                        'Reminder List',
                        style: getSemiBoldStyle(
                          fontSize: MyFonts.size18,
                          color: context.titleColor,
                        ),
                      ),
                      padding8,
                    ],
                  ),
                )),
            padding16,
            ReminderButton(
                upComingButton: () {
                  setState(() {
                    isPast = true;
                  });
                },
                pastButton: () {
                  setState(() {
                    isPast = false;
                  });
                },
                isPast: isPast),
            padding8,
            Consumer(builder: (context, ref, child) {
              final reminderState = ref.watch(getAllRemindersProvider);
              return reminderState.maybeWhen(
                data: (reminders) {
                  final upComingReminders = <ReminderModel>[];
                  final pastReminders = <ReminderModel>[];

                  for (final reminder in reminders) {
                    if (reminder.reminderDate.isAfter(DateTime.now())) {
                      upComingReminders.add(reminder);
                    } else {
                      pastReminders.add(reminder);
                    }
                  }
                  return isPast
                      ? ReminderList(
                    reminders: upComingReminders,
                  )
                      : ReminderList(
                    reminders: pastReminders,
                  );
                },
                orElse: () => LoadingWidget(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ReminderList extends StatelessWidget {
  final List<ReminderModel> reminders;

  const ReminderList({Key? key, required this.reminders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: reminders.isEmpty
          ? Text('No Reminder yet!',
          style: getSemiBoldStyle(color: context.bodyTextColor))
          : ListView.builder(
          itemCount: reminders.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            ReminderModel reminder = reminders[index];
            return InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () {
                  Navigator.pushNamed(
                      context, AppRoutes.placeDetailUsingIdScreen,
                      arguments: {'placeId': reminder.fsqId});
                },
                child: ReminderContainer(reminder: reminder));
          }),
    );
  }
}
