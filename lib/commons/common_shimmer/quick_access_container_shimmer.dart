import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../utils/thems/my_colors.dart';
import '../common_functions/padding.dart';
import 'loading_images_shimmer.dart';

class QuickAccessContainerShimmer extends StatelessWidget {
  const QuickAccessContainerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12.r),
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 0),
                color: context.titleColor.withOpacity(.10),
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: 80.w,
                  height: 20.h,
                ),
                padding4,
                ShimmerWidget(
                  width: 120.w,
                  height: 15.h,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: context.titleColor,
              size: 18.r,
            )
          ],
        ));
  }
}
