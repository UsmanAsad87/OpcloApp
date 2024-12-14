import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../../../commons/common_functions/padding.dart';
import '../../../../../../utils/constants/assets_manager.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../../../../utils/thems/styles_manager.dart';

class CategoriesOptions extends StatelessWidget {
  final BorderSide? bottomBorder;
  final String title;
  final String? icon;
  final Color? textColor;
  final Widget? trilling;

  const CategoriesOptions(
      {Key? key,
      this.bottomBorder,
      required this.title,
      this.icon,
      this.textColor,
      this.trilling})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.symmetric(vertical: 14.r),
      decoration: BoxDecoration(
        border: Border(
          top: bottomBorder ?? BorderSide.none,
          bottom: BorderSide(
              width: 1.5.r, color: context.titleColor.withOpacity(.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon == null
                  ? SizedBox(width: 0,)
                  : Image.asset(
                    icon!,
                    width: 19.w,
                    height: 18.h,
                    color: icon == AppAssets.starIconImage
                        ? context.titleColor.withOpacity(.4)
                        : null,
                  ),
              icon == null ? SizedBox(width: 0,) : padding8,
              Text(
                title,
                style: getMediumStyle(
                    color: textColor ?? context.titleColor.withOpacity(.5),
                    fontSize: MyFonts.size15),
              ),
            ],
          ),
          if (trilling != null) trilling!
        ],
      ),
    );
  }
}
