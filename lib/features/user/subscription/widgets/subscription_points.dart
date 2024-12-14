import 'package:flutter/material.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/my_colors.dart';

class SubscriptionPoints extends StatelessWidget {
  final String title;
  final String desc;

  const SubscriptionPoints({Key? key,required this.title,required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.r),
            child:  Icon(
              Icons.check_circle,
              color: MyColors.green,
              size: 22.r,
            ),
          ),
          padding8,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getSemiBoldStyle(
                    color: context.titleColor,
                    fontSize: MyFonts.size13),
              ),
              padding4,
              SizedBox(
                width: 260.w,
                child: Text(
                   desc,
                  style: getRegularStyle(
                      fontSize: MyFonts.size11,
                      color:
                      context.titleColor.withOpacity(.5.r)),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}
