import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class CustomFeedbackTextfield extends StatelessWidget {
  final TextEditingController responseController;
  const CustomFeedbackTextfield({Key? key, required this.responseController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
          color: context.containerColor,
          borderRadius: BorderRadius.circular(12.r)
      ),
      child: TextField(
        controller: responseController,
        decoration: InputDecoration(
          hintText: 'Please provide a response....',
          hintStyle: getMediumStyle(
              fontSize: MyFonts.size14,
              color: context.titleColor.withOpacity(.4)),
          enabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide.none
          ),
        ),
        maxLines: 5,
        onChanged: (value) {},

      ),
    );
  }
}
