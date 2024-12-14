import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class LocationWidget extends StatelessWidget {
  final Function() onTap;
  const LocationWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppAssets.noLocationImage,
          width: 300.w,
          height: 350.h,
        ),
        Padding(
          padding: EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Location Services turned off',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size18),
              ),
              //  padding8,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Text(
                  'Please enable location access to use Opclo',
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                      color: context.titleColor.withOpacity(.3),
                      fontSize: MyFonts.size13),
                ),
              ),
            ],
          ),
        ),
        CustomButton(
          onPressed: onTap,
          buttonText: 'Enable Now',
          buttonWidth: 200.w,
        )
      ],
    );
  }
}
