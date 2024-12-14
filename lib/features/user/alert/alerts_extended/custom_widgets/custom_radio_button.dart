import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../../commons/common_functions/padding.dart';
import '../../../../../utils/constants/assets_manager.dart';
import '../../../../../utils/thems/styles_manager.dart';
import 'custom_radio.dart';

class CustomRadioButton extends StatelessWidget {
  final String selectedRadioValue;
  final String value;
  final String buttonName;
  final String leadingIcon;
  final Function(bool?) onChange;

  const CustomRadioButton(
      {super.key,
      required this.selectedRadioValue,
      required this.value,
      required this.buttonName,
      required this.leadingIcon,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.containerColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                    color: context.whiteColor, shape: BoxShape.circle),
                child: Image.asset(
                  leadingIcon,
                  width: 26.w,
                  height: 26.h,
                ),
              ),
              padding16,
              Text(
                buttonName,
                style: getMediumStyle(
                    color: context.titleColor, fontSize: MyFonts.size14),
              ),
            ],
          ),
          CustomRadio(
            isSelected: selectedRadioValue == value,
            onChanged: onChange,
          ),
        ],
      ),
    );
  }
}
