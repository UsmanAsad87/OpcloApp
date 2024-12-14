import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../loading_images_shimmer.dart';

class CouponCardShimmer extends StatelessWidget {
  const CouponCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8.r),
        padding: EdgeInsets.all(8.r),
        width: 113.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: context.whiteColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 17.r,
                  color: context.titleColor.withOpacity(.10),
                  offset: const Offset(0, 0))
            ]),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                height: 80.h,
              ),
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
        )
    );
  }
}
