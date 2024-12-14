import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';

class LikeButton extends StatelessWidget {
  final bool isSelected;
  final Function() onTap;
  final String icon;
  // final bool isDislike;
  final Color buttonColor;

  const LikeButton(
      {Key? key,
      required this.isSelected,
      required this.onTap,
      required this.icon,
        required this.buttonColor,
      // this.isDislike = false
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
              color: context.whiteColor,
              border: !isSelected
                  ? Border.all(
                      width: 2.r, color: context.titleColor.withOpacity(.1))
                  : Border.all(color: context.whiteColor, width: 2.r),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                !isSelected
                    ? BoxShadow()
                    : BoxShadow(
                        blurRadius: 16,
                        color: context.titleColor.withOpacity(.10),
                        offset: Offset(0, 0),
                      ),
              ]),
          child: SvgPicture.asset(
            icon,
            color: isSelected ? buttonColor
            //     ? isDislike
            //         ? MyColors.red
            //         : MyColors.green
                : context.titleColor.withOpacity(.35),
            width: 29.w,
            height: 29.h,
          )),
    );
  }
}
