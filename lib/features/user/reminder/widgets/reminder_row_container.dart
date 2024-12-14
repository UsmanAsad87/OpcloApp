import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/reminder/widgets/profile_radio_button.dart';
import 'package:opclo/utils/constants/font_manager.dart';

class ReminderRowContainer extends StatelessWidget {
  final ValueChanged<bool?>? onChanged;
  final bool isSelected;
  final String icon;
  final String title;

  const ReminderRowContainer({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 24.h),
      decoration: BoxDecoration(
          color: context.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 11.r,
              offset: Offset(0, 0),
              color: context.titleColor.withOpacity(.10),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              padding8,
              Image.asset(icon, width: 22.w,height: 26.h,),
              padding16,
              Text(
                title,
                style: getMediumStyle(
                  color: context.titleColor,
                  fontSize: MyFonts.size16,
                ),
              ),
            ],
          ),
          ProfileRadioButton(isSelected: isSelected, onChanged: onChanged),
        ],
      ),
    );
  }
}
