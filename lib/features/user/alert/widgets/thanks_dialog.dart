import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';

class ThanksDialog extends StatelessWidget {
  const ThanksDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 50),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
            color: context.whiteColor,
            borderRadius: BorderRadius.circular(70.r),
            boxShadow: [
              BoxShadow(
                color: context.titleColor.withOpacity(.18),
                blurRadius: 20.r,
              )
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //     padding: EdgeInsets.all(18.r),
            //     margin: EdgeInsets.all(12.r),
            //     decoration: BoxDecoration(
            //       color: context.primaryColor,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Text(
            //       '+5',
            //       style: getSemiBoldStyle(
            //           color: context.whiteColor, fontSize: MyFonts.size28),
            //     )),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Thankyou',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size15)),
                SizedBox(
                  width: 180.w,
                  child: Text('Thanks! For helping others nearby.',
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                          color: context.titleColor.withOpacity(.5),
                          fontSize: MyFonts.size13)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
