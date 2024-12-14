import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_enum/coupons_category_enum/coupon_category.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/coupons/controller/coupon_notifier_controller.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class NoCoupons extends StatelessWidget {
  const NoCoupons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset(
            AppAssets.noCouponsBellImage,
            width: 150.w,
            height: 250.h,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Deal Available at This Moment',
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size18),
              ),
              padding8,
              Text(
                 "We’re sorry, check back soon for new offers! ☺️",
                textAlign: TextAlign.center,
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.3),
                    fontSize: MyFonts.size15),
              ),
            ],
          ),
        ),
        padding8,
        Consumer(builder: (context, ref, child) {
          final value = ref.watch(couponNotifierCtr).selectedIndex;
          return CustomButton(
            onPressed: () {
              ref.read(couponNotifierCtr).setSelectedOption(value == 0 ? 1 :value ==1 ?2: 0);

              // Navigator.pushNamed(context, AppRoutes.listOfCouponsScreen,
              //     arguments: {'category': CouponCategory.travel});
            },
            buttonText: value == 0
                ? 'Explore Online Deals'
                : value == 1
                    ? 'Explore In-Store Deals'
                    : 'Explore All Deals',
            buttonWidth: 227.w,
          );
        })
      ],
    );
  }
}
