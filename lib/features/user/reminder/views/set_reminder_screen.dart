import 'dart:math';

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:opclo/commons/common_enum/reminder_option/repeat_option.dart';
import 'package:opclo/commons/common_functions/date_time_format.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/reminder/controller/notification_service.dart';
import 'package:opclo/features/user/reminder/controller/reminder_controller.dart';
import 'package:opclo/models/reminder_model.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:uuid/uuid.dart';
import '../../../../models/place_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../widgets/reminder_row_container.dart';

class SetReminderScreen extends ConsumerStatefulWidget {
  final PlaceModel placeModel;

  const SetReminderScreen({
    Key? key,
    required this.placeModel,
  }) : super(key: key);

  @override
  ConsumerState<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends ConsumerState<SetReminderScreen> {
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  bool isInvite = false;
  bool isCalender = false;
  int selectedIndex = 0;
  List<String> repeatOptions = [
    'None',
    'Daily',
    'Weekends',
    'Weekly',
    'Monthly',
    'Yearly',
  ];
  RepeatOption? selectedRepeatOption = RepeatOption.None;


  save() {
    if (selectedRepeatOption == null) {
      showSnackBar(context, 'Please select repeat optiion');
    }
    ReminderModel reminderModel = ReminderModel(
        cancellationId : Random().nextInt(9999).toString(),
        id: Uuid().v4(),
        userId: ref.read(authNotifierCtr).userModel!.uid,
        userName: ref.read(authNotifierCtr).userModel!.userName,
        fsqId: widget.placeModel.fsqId,
        placeName: widget.placeModel.placeName,
        lat: widget.placeModel.lat,
        lng: widget.placeModel.lon,
        reminderDate: _currentDate2,
        repeatOption: selectedRepeatOption!,
        // inviteFriend: false,
        // inviteFriend: isInvite,
        addToCalendar: isCalender);
    ref
        .read(reminderControllerProvider.notifier)
        .addReminder(
        context: context,
        reminderModel: reminderModel,
      isInvite: isInvite
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: context.whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: context.whiteColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () {
                Navigator.of(context).pop();
              },
              splashColor: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: context.titleColor,
              ),
            ),
            title: Text(
              'Set Reminder',
              style: getSemiBoldStyle(
                color: context.titleColor,
                fontSize: MyFonts.size18,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: save,
                  child: Text(
                    'Save',
                    style: getMediumStyle(
                      color: context.primaryColor,
                      fontSize: MyFonts.size16,
                    ),
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    // margin: EdgeInsets.all(AppConstants.padding),
                    decoration: BoxDecoration(
                        color: context.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 11,
                            offset: Offset(0, 0),
                            color: context.titleColor.withOpacity(.10),
                          )
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatCalenderDate(_currentDate2),
                              style: getMediumStyle(
                                color: context.titleColor,
                                fontSize: MyFonts.size15,
                              ),
                            ),
                            InkWell(
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                              onTap: () async {
                                final timeOfDay = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      TimeOfDay.fromDateTime(_currentDate2),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: context.primaryColor,
                                          onPrimary: context.whiteColor,
                                          onSecondary: context.whiteColor,
                                          onSurface: context.primaryColor,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                context.primaryColor,
                                            // button text color
                                            textStyle: getSemiBoldStyle(
                                              color: context.primaryColor,
                                              fontSize: MyFonts.size16,
                                            ),
                                          ),
                                        ),
                                        // timePickerTheme: TimePickerThemeData(
                                        //   dayPeriodColor: context.primaryColor,
                                        // ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (timeOfDay != null) {
                                  final newDateTime = DateTime(
                                    _currentDate2.year,
                                    _currentDate2.month,
                                    _currentDate2.day,
                                    timeOfDay.hour,
                                    timeOfDay.minute,
                                  );
                                  setState(() {
                                    _currentDate2 = newDateTime;
                                  });
                                }
                              },
                              child: Text(
                                formatCalenderTime(_currentDate2),
                                style: getMediumStyle(
                                  color: context.titleColor,
                                  fontSize: MyFonts.size15,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Divider(
                            color: context.titleColor.withOpacity(.2),
                          ),
                        ),
                        CalendarCarousel<Event>(
                          weekDayMargin: EdgeInsets.zero,
                          pageSnapping: true,
                          dayPadding: 0,
                          todayBorderColor: context.primaryColor,
                          selectedDayBorderColor: context.primaryColor,
                          selectedDayButtonColor: context.primaryColor,
                          onDayPressed: (date, events) {
                            setState(() => _currentDate2 = date);
                            events.forEach((event) => debugPrint(event.title));
                          },
                          weekDayFormat: WeekdayFormat.standaloneNarrow,
                          weekdayTextStyle: TextStyle(
                            color: context.titleColor.withOpacity(.5),
                            fontSize: MyFonts.size15,
                          ),
                          weekDayPadding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                          ),
                          headerTextStyle: getMediumStyle(
                            color: context.bodyTextColor,
                            fontSize: MyFonts.size13,
                          ),
                          daysHaveCircularBorder: true,
                          showOnlyCurrentMonthDate: true,
                          // Show only dates in the current month
                          weekendTextStyle: TextStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size15,
                          ),
                          height: 260.h,
                          selectedDateTime: _currentDate2,
                          targetDateTime: _targetDateTime,
                          customGridViewPhysics: NeverScrollableScrollPhysics(),
                          showHeader: false,
                          selectedDayTextStyle: TextStyle(
                            color: context.whiteColor,
                          ),
                          minSelectedDate:
                              _currentDate2.subtract(Duration(days: 30)),
                          maxSelectedDate:
                              _currentDate2.add(Duration(days: 30)),
                          prevDaysTextStyle: TextStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size15,
                          ),
                          inactiveDaysTextStyle: TextStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size15,
                          ),
                          onCalendarChanged: (DateTime date) {
                            setState(() {
                              _targetDateTime = date;
                              _currentMonth =
                                  DateFormat.yMMM().format(_targetDateTime);
                            });
                          },
                          onDayLongPressed: (DateTime date) {
                            debugPrint('long pressed date $date');
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Text(
                      'Repeat',
                      style: getSemiBoldStyle(
                        color: context.titleColor,
                        fontSize: MyFonts.size16,
                      ),
                    ),
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                        childAspectRatio: 2.3.r),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: repeatOptions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            selectedRepeatOption =
                                repeatOptionFromString(repeatOptions[index]);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? context.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: context.titleColor.withOpacity(.2),
                                  width: 1.r)),
                          child: Center(
                            child: Text(repeatOptions[index],
                                style: getMediumStyle(
                                  color: selectedIndex == index
                                      ? context.whiteColor
                                      : context.titleColor.withOpacity(.5),
                                  fontSize: MyFonts.size13,
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                  padding16,
                  ReminderRowContainer(
                    isSelected: isInvite,
                    title: 'Invite People',
                    icon: AppAssets.addPersonIcon,
                    onChanged: (value) {
                      setState(() {
                        isInvite = !isInvite;
                      });
                    },
                  ),
                  ReminderRowContainer(
                    isSelected: isCalender,
                    title: 'Add to Calender',
                    icon: AppAssets.profileCalenderIcon,
                    onChanged: (value) {
                      setState(() {
                        isCalender = !isCalender;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        if (ref.watch(reminderControllerProvider))
          Container(
            decoration: BoxDecoration(
              color: context.titleColor.withOpacity(.4),
            ),
            child: Center(child: CircularProgressIndicator()),
          )
      ],
    );
  }
}
