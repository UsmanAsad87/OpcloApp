import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/models/alert_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';


class CustomDialog extends StatelessWidget {
  final String name;
  final AlertModel alert;
  const CustomDialog({super.key, required this.name, required this.alert});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding, vertical: 50.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: MyColors.notificationColor.withOpacity(0.95),
        ),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Attention',
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                  fontSize: MyFonts.size16,
                  color: context.whiteColor,
                  // decoration: TextDecoration.none
                ),
              ),
              padding4,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 290.w,
                    child: Text(
                      '$name ${alert.option.type}', //'$name is only taking drive thru orders at this moment.',
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                        fontSize: MyFonts.size13,
                        color: context.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              padding4,
              Text(
                'Swipe up to dismiss',
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontSize: MyFonts.size13,
                  color: context.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
