import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/notification/widgets/select_mute_time.dart';
import 'package:opclo/features/user/restaurant/controller/place_subscription_controller.dart';
import 'package:opclo/utils/loading.dart';

import '../../../../commons/common_enum/notification_enum.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../commons/common_widgets/custom_outline_button.dart';
import '../../../../firebase_messaging/service/notification_service.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../reminder/controller/notification_service.dart';

class MuteBottomSheet extends StatelessWidget {
  final String placeId;
  final NotificationEnum notificationType;
  final int? reminderId;

  MuteBottomSheet({
        Key? key,
        required this.placeId,
        required this.notificationType,
    this.reminderId
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360.h,
      decoration: BoxDecoration(
        color: context.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 5.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              width: 66.w,
              height: 6.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: context.titleColor.withOpacity(.2),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.w, 8.h, 8.w, 15.h),
            child: Text(
              'Mute Alert',
              style: getSemiBoldStyle(
                  color: context.titleColor, fontSize: MyFonts.size18),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: timeOptions.length,
            itemBuilder: (context, index) {
              return Consumer(builder: (context, ref, child) {
                return InkWell(
                  // onTap: () {
                  //   DateTime date;
                  //   if (index == 0) {
                  //     date = DateTime.now().add(Duration(days: 1));
                  //   } else if (index == 1) {
                  //     date = DateTime.now().add(Duration(days: 7));
                  //   } else if (index == 2) {
                  //     date = DateTime.now().add(Duration(days: 30));
                  //   } else {
                  //     date = DateTime.now().add(Duration(days: 2000));
                  //   }
                  //   if (notificationType == NotificationEnum.alert) {
                  //     ref.read(placeSubControllerProvider.notifier)
                  //         .updateUserIdInPlaceSub(
                  //       placeId: placeId,
                  //       date: date,
                  //     );
                  //   }else if(notificationType == NotificationEnum.reminder){
                  //     LocalNotificationService().cancelNotification(id: reminderId!);
                  //   }
                  // },
                  child: SelectableMuteOption(
                    index: index,
                    label: timeOptions[index],
                    onTap: () {
                      DateTime date;
                      if (index == 0) {
                        date = DateTime.now().add(Duration(days: 1));
                      } else if (index == 1) {
                        date = DateTime.now().add(Duration(days: 7));
                      } else if (index == 2) {
                        date = DateTime.now().add(Duration(days: 30));
                      } else {
                        date = DateTime.now().add(Duration(days: 2000));
                      }
                      if (notificationType == NotificationEnum.alert) {
                        ref.read(placeSubControllerProvider.notifier)
                            .updateUserIdInPlaceSub(
                          placeId: placeId,
                          date: date,
                        );
                      }else if(notificationType == NotificationEnum.reminder){
                        LocalNotificationService().cancelNotification(id: reminderId!);
                      }
                    },
                  ),
                );
              });
            },
          ),
        ]),
      ),
    );
  }

  List<String> timeOptions = [
    "1 Day",
    "1 Week",
    "1 Month",
    "Turn off Alerts",
  ];
}
