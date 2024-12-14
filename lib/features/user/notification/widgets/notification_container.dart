import 'package:flutter/material.dart';
import 'package:opclo/commons/common_enum/notification_enum.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/notification/widgets/mute_bottom_sheet.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../models/notification_model.dart';

class NotificationContainer extends StatelessWidget {
  final NotificationModel notificationModel;
  final String icon;
  final String time;
  final String title;
  final String subtitle;
  final bool isMute;

  const NotificationContainer({
    Key? key,
    required this.notificationModel,
    required this.icon,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.isMute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (notificationModel.notificationType == NotificationEnum.admin) {
        } else {
          Navigator.pushNamed(context, AppRoutes.placeDetailUsingIdScreen,
              arguments: {'placeId': notificationModel.placeId});
        }
      },
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
            color: context.whiteColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 50.r,
                offset: Offset(0, 0),
                color: context.titleColor.withOpacity(.10),
              )
            ],
            borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          children: [
            Container(
              // width: 80.w,
              height: 100.h,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
              decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12.r)),
              child: Image.asset(
                icon,
                width: 28.w,
                height: 28.h,
                color: context.primaryColor,
              ),
            ),
            padding12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: getSemiBoldStyle(
                            color: MyColors.redText, fontSize: MyFonts.size11),
                      ),
                      if (isMute)
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                enableDrag: true,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                // context.titleColor.withOpacity(
                                //     .05.r),
                                builder: (context) {
                                  return MuteBottomSheet(
                                      placeId: notificationModel.placeId,
                                      notificationType:
                                          notificationModel.notificationType,
                                      reminderId: notificationModel.reminderId);
                                });
                          },
                          child: Text(
                            'Mute',
                            style: getSemiBoldStyle(
                                color: context.primaryColor,
                                fontSize: MyFonts.size11),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  'NOTIFICATION',
                  style: getMediumStyle(
                      color: context.titleColor.withOpacity(.6),
                      fontSize: MyFonts.size11),
                ),
                Text(
                  title,
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size15),
                ),
                SizedBox(
                  width: 200.w,
                  child: Text(
                    subtitle,
                    style: getRegularStyle(
                        color: context.titleColor.withOpacity(.5),
                        fontSize: MyFonts.size11),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
