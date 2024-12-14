import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class CouponsChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  const CouponsChip({Key? key, required this.text, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      margin: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor
              : context.containerColor,
          borderRadius: BorderRadius.circular(50.r)),
      child: Center(
        child: Text(
          text,
          style: getSemiBoldStyle(
              color: isSelected
                  ? context.whiteColor
                  : context.titleColor.withOpacity(.4.r),
              fontSize: MyFonts.size12),
        ),
      ),
    );
  }
}
