import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';

import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/my_colors.dart';
import '../../../../utils/thems/styles_manager.dart';

class CustomAboutButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final String? image;
  final Color? fillColor;
  final Function()? onTap;

  const CustomAboutButton({
    Key? key,
    required this.text,
    this.icon,
    this.image,
    this.fillColor,
    this.onTap

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(image != null ? 9.r : 8.r),
              decoration: BoxDecoration(
                  color: fillColor ?? Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1.5, color: context.primaryColor,)),
              child: icon == null ? Image.asset(image!, width: 20.w,height: 20.h,): Icon(
                icon,
                color: context.primaryColor,
                size: 20.r,
              )),
          Padding(
            padding:  EdgeInsets.all(6.r),
            child: Text(
              text,
              style: getMediumStyle(
                  color: context.titleColor,
                  fontSize: MyFonts.size12),
            ),
          ),
        ],
      ),
    );
  }
}
