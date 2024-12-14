import 'package:flutter/material.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/notification/widgets/mute_bottom_sheet.dart';
import 'package:opclo/utils/constants/font_manager.dart';

class CouponContainerNotification extends StatefulWidget {
  final String icon;
  final String time;
  final String title;
  final String subtitle;
  final Color bgColor;
  final String type;

  const CouponContainerNotification({
    Key? key,
    required this.icon,
    required this.time,
    required this.title,
    required this.subtitle, required this.bgColor, required this.type,
  }) : super(key: key);

  @override
  State<CouponContainerNotification> createState() => _CouponContainerNotificationState();
}

class _CouponContainerNotificationState extends State<CouponContainerNotification> {
  bool isAddedToWallet=false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
           width: 70.w,
            height: 100.h,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
            decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(12.r)),
            child: Image.asset(
              widget.icon,
              width: 40.w,
              height: 40.h,
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
                      widget.time,
                      style: getSemiBoldStyle(
                          color: MyColors.redText, fontSize: MyFonts.size11),
                    ),
                    if(!isAddedToWallet)
                    InkWell(
                      onTap: (){
                        setState(() {
                          isAddedToWallet=true;
                        });

                      },
                      child: Text(
                        '+ add to wallet',
                        style: getSemiBoldStyle(
                            color: context.primaryColor, fontSize: MyFonts.size11),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.type,
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.6),
                    fontSize: MyFonts.size11),
              ),
              Text(
                widget.title,
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size15),
              ),
              SizedBox(
                width: 200.w,
                child: Text(
                 widget.subtitle,
                  style: getRegularStyle(
                      color: context.titleColor.withOpacity(.5),
                      fontSize: MyFonts.size11),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
