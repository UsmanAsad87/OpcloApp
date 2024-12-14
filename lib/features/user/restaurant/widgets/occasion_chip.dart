import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class OccasionChip extends StatelessWidget {
  final String title;
 final String icon;

  const OccasionChip({
    Key? key, required this.title,
   required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12.w ),
      padding:
      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 30.r,
            spreadRadius: 0,
            offset: Offset(0, 10),
            color: context.titleColor.withOpacity(.10),
          ),
        ],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
          children: [
        Image.asset(
          icon,
          width: 18.w,
          height: 20.h,
        ),
        padding8,
        Text(
          title,
          style: getMediumStyle(
              color: context.titleColor,
              fontSize: MyFonts.size13),
        ),
      ]),
    );
  }
}
