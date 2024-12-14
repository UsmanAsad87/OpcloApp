import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../utils/thems/styles_manager.dart';

class SearchRow extends StatelessWidget {
  final icon;
  final color;
  final title;
  TextStyle? style;
   SearchRow({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    this.style
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.containerColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color ?? context.titleColor,
            size: 16.r,
          ),
          padding8,
          Text(
            title,
            style: style ?? getRegularStyle(
              color: color ?? context.titleColor,
              fontSize: MyFonts.size12
            ),
          ),
        ],
      ),
    );
  }
}
