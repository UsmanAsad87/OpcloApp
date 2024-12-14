import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_enum/notification_enum.dart';
import '../../../../commons/common_enum/reminder_option/repeat_option.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/notification_model.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../notification/controller/notification_controller.dart';
import '../../notification/helper/notification_helper.dart';

class NotificationIconWidget extends StatelessWidget {
  const NotificationIconWidget({
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.r),
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.notificationScreen);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              AppAssets.notification,
              width: 21.w,
              height: 26.h,
              colorFilter: ColorFilter.mode(
                context.titleColor.withOpacity(.3),
                BlendMode.srcIn,
              ),
            ),
            Positioned(
              top: -6,
              right: -2,
              child: Consumer(builder: (context, ref, child) {
                return ref.watch(fetchAllNotificationProvider).when(
                    data: (notifications) {
                      if (notifications.isNotEmpty) {
                        int i = 0;
                        notifications.forEach((noti) {
                          if (noti.notificationType == NotificationEnum.reminder) {
                            if (shouldDisplayNotification(noti)) {
                              i++;
                            }
                          } else {
                            i++;
                          }
                        });
                        if (i == 0) {
                          return SizedBox();
                        }
                        return Container(
                          padding: EdgeInsets.all(5.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.primaryColor,
                          ),
                          child: Text(
                            '$i',
                            style: getSemiBoldStyle(
                              color: Colors.white,
                              fontSize: MyFonts.size8,
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                    error: (error, stackTrace) => SizedBox(),
                    loading: () => SizedBox());
              }),
            ),
          ],
        ),
      ),
    );
  }
}
