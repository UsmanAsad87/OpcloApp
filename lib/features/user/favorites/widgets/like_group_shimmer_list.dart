import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_shimmer/loading_images_shimmer.dart';

class LikeGroupShimmerList extends StatelessWidget {
  const LikeGroupShimmerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => Divider(
          color: context.titleColor.withOpacity(.3),
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget(
                  width: 50.w,
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Icon(
                    CupertinoIcons.suit_heart_fill,
                    size: 26.r,
                    color: context.titleColor.withOpacity(.23),
                  ),
                )
              ],
            ),
          );
        });
  }
}
