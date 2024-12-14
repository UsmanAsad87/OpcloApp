import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class NotificationAndCouponButton extends StatelessWidget {
  final notificationButton;
  final couponButton;
  final bool isNotification;

  const NotificationAndCouponButton(
      {Key? key,
      required this.couponButton,
      required this.notificationButton,
      required this.isNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
          color: context.primaryColor.withOpacity(.15),
          borderRadius: BorderRadius.circular(6.r)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: notificationButton,
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                      color: isNotification
                          ? context.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r)),
                  child: Center(
                      child: Text(
                    'Notification',
                    style: getSemiBoldStyle(
                        color: isNotification
                            ? context.whiteColor
                            : context.primaryColor,
                        fontSize: MyFonts.size13),
                  ))),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: couponButton,
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                      color: !isNotification
                          ? context.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r)),
                  child: Center(
                      child: Text(
                    'Coupons',
                    style: getSemiBoldStyle(
                      color: !isNotification
                          ? context.whiteColor
                          : context.primaryColor,
                      fontSize: MyFonts.size13,
                    ),
                  ))),
            ),
          )
        ],
      ),
    );
  }
}
