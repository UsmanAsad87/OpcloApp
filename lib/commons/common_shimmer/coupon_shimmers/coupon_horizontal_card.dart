import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../loading_images_shimmer.dart';

class CouponHorizontalCard extends StatelessWidget {
  const CouponHorizontalCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 6.h, left: 2.w, right: 2.w, top: 2.h),
        padding: EdgeInsets.all(8.r),
        width: 0.88.sw,
        height: 110.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: context.whiteColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 10,
                  color: context.titleColor.withOpacity(.1.r),
                  offset: const Offset(0, 4))
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(
              height: 80.h,
              width: 80.w,
            ),
            padding8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 4.h),
                  child: ShimmerWidget(
                    height: 20.h,
                    width: 50.w,
                  ),
                ),
                ShimmerWidget(
                  height: 30.h,
                  width: 70.w,
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 4.h),
                  child: ShimmerWidget(
                    height: 20.h,
                    width: 90.w,
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}
