import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/models/coupon_model.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_widgets/cached_retangular_network_image.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class CouponHorizontalContainer extends StatelessWidget {
  final CouponModel couponModel;

  const CouponHorizontalContainer({Key? key, required this.couponModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.couponsDetailScreen,
            arguments: {'couponModel': couponModel});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 6.h, left: 2.w, right: 2.w, top: 2.h),
        padding: EdgeInsets.all(8.r),
        width: 0.88.sw,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: context.whiteColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 10,
                  color: context.titleColor.withOpacity(.1.r),
                  offset: const Offset(0, 4))
            ]),
        child: Row(
          children: [
            CachedRectangularNetworkImageWidgetCoupon(
              image: couponModel.logo,
              width: 98,
              height: 83,
              fit: BoxFit.contain,
              fontSize: MyFonts.size12,
            ),
            padding8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    couponModel.type.type,
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.5.r),
                        fontSize: MyFonts.size10),
                  ),
                  Text(
                    couponModel.title,
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size14),
                  ),
                  Text(
                    couponModel.shortDescription,
                    style: getRegularStyle(
                        color: context.titleColor.withOpacity(.5.r),
                        fontSize: MyFonts.size11),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
