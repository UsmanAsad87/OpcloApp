import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class NoPlaceOpenBody extends StatelessWidget {
  final Function() onTap;
  const NoPlaceOpenBody({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppAssets.noPlaceImage,
          width: 300.w,
          height: 350.h,
        ),
        Padding(
          padding: EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No places Open',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size18),
              ),
            //  padding8,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Text(
                  'Sorry, there aren’t any open places in your area at the moment.',
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
          buttonText: 'Search again',
          buttonWidth: 200.w,
        )
      ],
    );
  }
}
