import 'package:flutter/cupertino.dart';
import 'package:opclo/commons/common_functions/date_time_format.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/models/reminder_model.dart';
import 'package:opclo/utils/constants/font_manager.dart';

class ReminderContainer extends StatelessWidget {
  final ReminderModel reminder;
  const ReminderContainer({
    Key? key,
    required  this.reminder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.whiteColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 11,
            color: context.titleColor.withOpacity(.05),
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(12.r)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reminder.placeName,
            style: getMediumStyle(
                color: context.titleColor, fontSize: MyFonts.size15),
          ),
          padding8,
          Row(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(.15),
                        shape: BoxShape.circle),
                    child: Icon(
                      CupertinoIcons.clock,
                      color: context.primaryColor,
                      size: 13.r,
                      weight: 800,
                    ),
                  ),
                  padding8,
                  Text(
                    formatFullTime(reminder.reminderDate),
                    style: getRegularStyle(
                        color: context.titleColor.withOpacity(.5),
                        fontSize: MyFonts.size13),
                  )
                ],
              ),
              padding16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(.15),
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: context.primaryColor,
                      size: 13.r,
                      weight: 800,
                    ),
                  ),
                  padding8,
                  Text(
                    reminder.repeatOption.name,
                    style: getRegularStyle(
                        color: context.titleColor.withOpacity(.5),
                        fontSize: MyFonts.size13),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
