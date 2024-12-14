import 'package:flutter/material.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../utils/thems/styles_manager.dart';

class IconTextRow extends StatelessWidget {
  final text;

  const IconTextRow({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: context.primaryColor,
            size: 17.r,
          ),
          padding4,
          Text(
            text,
            style: getMediumStyle(
                color: context.titleColor, fontSize: MyFonts.size15),
          )
        ],
      ),
    );
  }
}
