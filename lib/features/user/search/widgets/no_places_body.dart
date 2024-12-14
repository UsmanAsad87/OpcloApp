import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class NoPlaceWidget extends StatelessWidget {
  const NoPlaceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        padding40,
        Image.asset(
          AppAssets.noPlaceImage,
          width: 200.w,
          height: 200.h,
        ),
        Padding(
          padding: EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No places Found',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size18),
              ),
              //  padding8,
            ],
          ),
        ),
      ],
    );
  }
}
