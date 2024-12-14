import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

class IconWidget extends StatelessWidget {
  final String icon;
  final double size;
  final double? padding;
  const IconWidget({Key? key, required this.icon, required this.size, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 16.r),
      decoration: BoxDecoration(
        color: context.whiteColor,
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        icon,
        width: size.w,
        height: size.h,
      ),
    );
  }
}
