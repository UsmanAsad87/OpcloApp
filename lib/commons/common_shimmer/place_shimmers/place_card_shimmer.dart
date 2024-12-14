import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/assets_manager.dart';
import '../../../utils/thems/my_colors.dart';
import '../../common_functions/padding.dart';
import '../loading_images_shimmer.dart';

class PlaceCardShimmer extends StatelessWidget {
  final double? width;
  final double? rightMargin;
  final double? leftMargin;

  const PlaceCardShimmer({Key? key, this.width, this.rightMargin, this.leftMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
          top: 12.h,
          bottom: 12.h,
          left: 12.w,
          right: rightMargin ?? 12.w),
      margin: EdgeInsets.only(
          top: 8.h, bottom: 8.h,
          left: leftMargin ?? 8.w,
          right: rightMargin ?? 8.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: context.whiteColor,
          boxShadow: [
            BoxShadow(
                blurRadius: 10.r,
                spreadRadius: 0,
                color: MyColors.shadowColor.withOpacity(.30.r),
                offset: Offset(0, 1.h))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: ShimmerWidget(
                    height: 135.h,
                  )),
              Padding(
                padding: EdgeInsets.all(AppConstants.allPadding),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.r, horizontal: 8.r),
                        decoration: BoxDecoration(
                          // color: widget.placeModel?.isOpen ?? true
                          //     ? MyColors.green
                          //     : MyColors.red,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ShimmerWidget(
                          height: 20.h,
                          width: 40.w,
                          highlightColor: MyColors.green,
                          baseColor: context.titleColor.withOpacity(.5),
                        )),
                    padding8,
                    ShimmerWidget(
                      height: 20.h,
                      width: 40.w,
                      highlightColor: context.whiteColor,
                      baseColor: context.titleColor.withOpacity(.5),
                    ),
                  ],
                ),
              )
            ],
          ),
          padding16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 180.w,
                          child: ShimmerWidget(
                            width: 200.w,
                            height: 25.h,
                          )),
                      padding8,
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                            color:
                                MyColors.starContainerColor.withOpacity(.1.r),
                            borderRadius: BorderRadius.circular(4.r)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: MyColors.starContainerColor,
                              size: 14.r,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            ShimmerWidget(
                              width: 20.w,
                              height: 15,
                              baseColor: context.titleColor.withOpacity(.3),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  padding4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppAssets.container_location,
                        width: 14.w,
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      SizedBox(
                          width: 190.w,
                          child: ShimmerWidget(
                            width: 200.w,
                            height: 20.h,
                          ))
                    ],
                  ),
                ],
              ),
              Container(
                  width: 40.w,
                  height: 40.h,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: MyColors.heartColor.withOpacity(.3),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Icon(
                    CupertinoIcons.suit_heart_fill,
                    size: 23.sp,
                    color: false ? MyColors.redText : MyColors.heartColor,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
